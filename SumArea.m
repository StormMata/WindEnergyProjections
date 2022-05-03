function [TotalArea,FreeArea,Lats,Lons] = SumArea(grid, gridR, combW)
%SumArea calculates the total area for two cases
%   Calculates the total area for the two following cases:
%       1. The total area bounded within the borders of the contiguous US
%       2. The land area remaining after the following map layers have been
%          subtracted from the full US map:
%               - agricultural development
%               - standing water
%               - urban development
%               - forest coverage
%               - elevation gradient

    fprintf('\n------------------------')                                   % Print current function to screen
    fprintf('\n---Area Calculations----\n')
    LL = fprintf('Complete:         XXX.XXX');

    latvec = flip(linspace(gridR.LatitudeLimits(1), ...                     % Generate vector of reference latitudes
             gridR.LatitudeLimits(2),size(grid,1)));
    lonvec = linspace(gridR.LongitudeLimits(1),gridR.LongitudeLimits(2), ...% Generate vector of reference longitudes
             size(grid,2));

    earthellipsoid = referenceSphere('earth','mile');                       % Set the reference datum for the area calculations

    TotalArea = 0;                                                          % Initialize total US area variable
    FreeArea  = 0;                                                          % Initialize total wind energy development area variable
    Total = length(latvec) * length(lonvec);                                % Total number of quadrants in bounded area
    Count = 0;                                                              % Progress counter
    Tally = 1;                                                              % Free quadrant counter
    
    for j = 2:size(grid,2)

        for i = 2:size(grid,1)

            if mod(Count,10000) == 0
                fprintf(repmat('\b',1,LL))
                fprintf('Complete:         %6.2f%%',(Count/Total)*100)      % Print progress to screen
            end

            if ~isnan(grid(i,j))

%                 TotalArea = TotalArea + eartharea(latvec(i-1), ...              % Sum total area in the continental US
%                             lonvec(j-1),latvec(i),lonvec(j),earthellipsoid);

            end

            if ~isnan(combW(i,j))

%                 FreeArea = FreeArea + eartharea(latvec(i-1),lonvec(j-1), ... % Sum area available for wind energy expansion
%                            latvec(i),lonvec(j),earthellipsoid);

                Lats(Tally) = i;                                            % Record latitudes of available wind farm site
                Lons(Tally) = j;                                            % Record longitudes of available wind farm site

                Tally = Tally + 1;                                          % Tally number of sites
            end

            Count = Count + 1;                                              % Update progress counter

        end
    end

%     function area = eartharea(lat1,lon1,lat2,lon2,ellipsoid)                % This function computes the area bounded by the lats/lons
% 
%         [lat1,lon1,lat2,lon2] = toRadians('degrees',lat1,lon1,lat2,lon2);
%         lat1 = convertlat(ellipsoid, lat1, 'geodetic', 'authalic', 'nocheck');
%         lat2 = convertlat(ellipsoid, lat2, 'geodetic', 'authalic', 'nocheck');
%         radius = rsphere('authalic',ellipsoid);
% 
%         a = abs(lon1-lon2) .* abs(sin(lat1)-sin(lat2)) / (4*pi);
% 
%         area = a * 4*pi*radius^2;
% 
%     end

    fprintf(repmat('\b',1,LL))
    fprintf('------------------------\n')                                   % Print progress to screen

end
