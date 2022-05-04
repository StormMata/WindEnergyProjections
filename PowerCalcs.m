function [Outputs] = PowerCalcs(Lons,Lats,grid, latlim,lonlim)
%PowerCalcs Simulates the annual new wind power installations
%   Takes in geospatial data and wind turbine trend information to simulate
%   annual new wind turbine capacity (in GW) installations based on site
%   availability

    fprintf('\n------------------------')                                   % Print current function to screen
    fprintf('\n---Power Calculations---\n')
    LL = fprintf('Year:               XXXX');
    
    earthellipsoid = referenceSphere('earth','mile');                       % Set the reference datum for the area calculations

    latvec = flip(linspace(latlim(1),latlim(2),size(grid,1)));              % Generate vector of reference latitudes
    lonvec = linspace(lonlim(1),lonlim(2),size(grid,2));                    % Generate vector of reference longitudes
    
    lonind(1) = find(lonvec < -104,1,'last');                               % Find last index in lonvec outside of target region
    lonind(2) = find(lonvec > -96,1,'first');                               % Find first index in lonvec outside of target region
    
    Lons(Lons < lonind(1)) = 0;                                             % Set longitudes west of target region to zero
    Lons(Lons > lonind(2)) = 0;                                             % Set longitudes east of target region to zero
    
    Lats = Lats .* (Lons > 0);                                              % Filter out cooresponding latitudes
    
    Lons = nonzeros(Lons);                                                  % Discard longitudes set to zero
    Lats = nonzeros(Lats);                                                  % Discard latitudes set to zero
    
    years = 2022:2080;                                                      % Define time horizon vector
    AnnualNewCap = zeros(1,length(years));                                  % Preallocate vector of annual new capacity predictions
    
    NCapBenchmarks = [2020 2025 2030 2035 2040 2045 2050 2075;              % Matrix of literature values for future annual capacity installations
                       7.5   12   14 13.5   17   18   22   35];
    
    MWBenchmarks   = [2013 2020 2030 2050;                                  % Matrix of literature values for future turbine power ratings
                       1.9  2.8 4.08  6.1];
    
    NewCap = interp1(NCapBenchmarks(1,:),NCapBenchmarks(2,:),2022:2080, ... % Interpolate benchmark new capacity values
             "makima","extrap");
    
    NewMW = interp1(MWBenchmarks(1,:),MWBenchmarks(2,:),2022:2080, ...      % Interpolate benchmark turbine power rating values
            "makima","extrap");
    
    rLats = Lats;                                                           % Define reserve of latitudes
    rLons = Lons;                                                           % Define reserve of longitudes
    
    for y = 1:length(years)
    
        fprintf(repmat('\b',1,LL))
        fprintf('Year:               %4.0f',years(y))                       % Update progress to screen
    
        Outputs.(sprintf('Coords%4.0f',years(y)))  = [];                    % Preallocate structure of outputs
        Outputs.(sprintf('Area%4.0f',years(y)))    = [];
        Outputs.(sprintf('NewCap%4.0f',years(y)))  = [];
        Outputs.(sprintf('PredCap%4.0f',years(y))) = [];
    
        CSum = 0;                                                           % Reset annual simulated new capacity summation
    
        mu = NewCap(years == years(y));                                     % Find literature predicted value for new capacity based on the current year in the simulation
    
        AnnualNewCap(y) = floor(random('Normal',mu,2));                     % Predict yearly new capacity based on a normal distribution about literature values
    
        while CSum < (0.9 * AnnualNewCap(y))
        
            radius = randi([10 23]);                                        % Select a radius for the new wind farm. This is a proxy for the overall size of the wind farm
            
            randind = randi([1 length(Lats)]);                              % Select a location for the new wind farm inside the target region
            
            point = [Lats(randind) Lons(randind)];                          % Get latitude and longitude of new wind farm location
    
            AreaSum = 0;
    
            latindices = find(rLats > point(1)-radius & rLats < ...         % Speed up the simulation by filtering out latitudes far from the new wind farm location
                         point(1)+radius);
            lonindices = find(rLons > point(2)-radius & rLons < ...         % Do the same for longitudes
                         point(2)+radius);
    
            comindices = nonzeros(latindices .* ismember(latindices, ...    % Get indices for selected areas around target location
                         lonindices));
            
            for i = 1:length(rLats(comindices))
    
                BinRes = abs(sqrt((rLats(comindices(i))-point(1)).^2 + ...  % Binary result: 0 location is not inside the wind farm radius; 1 location is inside wind farm radius
                         (rLons(comindices(i))-point(2)).^2)) <= radius;
    
                if BinRes == 1
    
                    AreaSum = AreaSum + areaquad(latvec(rLats( ...          % Computes the area of quadrants that are found to be inside the wind farm radius
                              comindices(i))-1), lonvec(rLons( ...
                              comindices(i))-1), latvec(rLats( ...
                              comindices(i))),lonvec(rLons( ...
                              comindices(i))),earthellipsoid);
    
                    CSum = CSum + ((AreaSum / 0.09) * NewMW(y)/1000);       % Use the literature values for turbine power rating and turbine spacing to find new capacity
    
                    rLats(comindices(i)) = 0;                               % Remove selected latitudes from future consideration for wind farm placement
                    rLons(comindices(i)) = 0;                               % Do the same for longitudes
    
                end
    
                rLats = nonzeros(rLats);                                    % Remove zeroed latitudes from vector
                rLons = nonzeros(rLons);                                    % Remove zeroed longitudes from vector
            
            end
    
            Outputs.(sprintf('Coords%4.0f',years(y))) = [Outputs.( ...      % Store wind farm locations
                sprintf('Coords%4.0f',years(y))); point];
            Outputs.(sprintf('Area%4.0f',years(y)))   = [Outputs.( ...      % Store cooresponding wind farm areas
                sprintf('Area%4.0f',years(y))); AreaSum];
    
        end
    
        CapSum(y) = CSum;                                                   % Update new capacity total

        Outputs.(sprintf('NewCap%4.0f',years(y)))  = [Outputs.( ...         % Store total new capacity for current year
            sprintf('NewCap%4.0f',years(y))); CapSum(y)];
        Outputs.(sprintf('PredCap%4.0f',years(y))) = [Outputs.( ...         % Store predicted total new capacity for current year
            sprintf('PredCap%4.0f',years(y))); AnnualNewCap(y)];
    
    end

    fprintf(repmat('\b',1,LL))
    fprintf('------------------------\n')                                   % Update console

end