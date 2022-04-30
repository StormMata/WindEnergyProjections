function [grid,gridR] = WaterArea(CPD)
%WaterArea plots geospatial water area
%   Plots geospatial data for standing water in the US

    addpath('/Users/stormmata/Library/Mobile Documents/com~apple~CloudDocs/Courses/2021 Spring/1.001/Project');
    addpath('/Users/stormmata/Downloads/CropData');
    addpath('/Users/stormmata/Downloads/2021_30m_cdls');
    addpath('/Users/stormmata/Downloads/urbanspatial-urban-extents-viirs-modis-us-2015-geotiff');
    
    latlim = [23,50];                                                       % Latitude limits for US
    lonlim = [-127,-65];                                                    % Longitude limits for US
    
    cellperdeg = CPD;                                                       % Number of cells per degree of lat/long
    
    grid = zeros((latlim(2) - latlim(1)) * cellperdeg,(abs(lonlim(1)) ...   % Preallocate full US grid
           - abs(lonlim(2))) * cellperdeg);
    
    latvec = flip(linspace(latlim(1),latlim(2),size(grid,1)));              % Vector of latitudes
    lonvec = linspace(lonlim(1),lonlim(2),size(grid,2));                    % Vector of longitudes

    water = [83,87,111,190];                                                % Water codes
    
    for i = 1:31
    
        [A,R] = readgeoraster(sprintf('%1.0f.tif',i));                      % Import raw geotif data
    
        latnum = ceil((R.LatitudeLimits(2) - R.LatitudeLimits(1)) * ...     % Find number of latitude cells for geotiff data
                 cellperdeg);
        lonnum = ceil((abs(R.LongitudeLimits(1)) - abs( ...                 % Find longitude cells for geotiff data
                 R.LongitudeLimits(2))) * cellperdeg);
        
        A = A(floor(linspace(1,size(A,1),latnum)),floor(linspace( ...       % Sample geotiff data with 
            1,size(A,2),lonnum)));
        R.RasterSize = [size(A,1),size(A,2)];                               % Modify geocellreference structure
    
        A = double(A);                                                      % Convert geotif data from int to double

        for j = 1:length(water)
        
            A(A==water(j)) = 1;                                             % Convert all crop data to 1
        
        end
    
        A(A > 1) = 0;                                                       % Convert non-crop data to 0
    
        latind = find(latvec > R.LatitudeLimits(2),1,"last");               % Find coordinates for geotif file reference
        lonind = find(lonvec < R.LongitudeLimits(1),1,"last");
    
        grid(latind:(latind - 1 + size(A,1)),lonind:(lonind - 1 + ...       % Insert geotiff data into full US grid
            size(A,2))) = grid(latind:(latind - 1 + size(A,1)),lonind: ...
            (lonind - 1 + size(A,2))) + A;
    
    end
    
    gridR = R;                                                              % Duplicate geocellreference structure
    gridR.LatitudeLimits  = [latvec(end) latvec(1)];                        % Set latitude limits
    gridR.LongitudeLimits = [lonvec(1) lonvec(end)];                        % Set longitude limits
    gridR.RasterSize      = [size(grid,1) size(grid,2)];                    % Set raster size
    
    grid(grid == 0) = NaN;                                                  % Convert all 0s to NaN 
    grid(grid > 1)  = 1;                                                    % Reset all nonzeros values to 1

end