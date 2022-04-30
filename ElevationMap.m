function [elev,elevR] = ElevationMap(CPD, latlim, lonlim, grid)
%ElevationMap processes geospatial elevation data
%   Takes in unformatted geospatial elevation data and filters out
%   extraneous data by setting values to NaN

    addpath('/Users/stormmata/Downloads/TiffData');
    
    [A1,R1] = readgeoraster('Elevation-R1-C1.tif');                         % Panel: Row 1, Column 1
    [A2,~]  = readgeoraster('Elevation-R1-C2.tif');                         % Panel: Row 1, Column 2
    [A3,~]  = readgeoraster('Elevation-R1-C3.tif');                         % Panel: Row 1, Column 3
    [A4,~]  = readgeoraster('Elevation-R2-C1.tif');                         % Panel: Row 2, Column 1
    [A5,~]  = readgeoraster('Elevation-R2-C2.tif');                         % Panel: Row 2, Column 2
    [A6,R6] = readgeoraster('Elevation-R2-C3.tif');                         % Panel: Row 2, Column 3
    
    A = [A1,A2,A3;A4,A5,A6];                                                % Combine all panels
    
    R = R1;                                                                 % Generate geocellreference structure
    
    R.LatitudeLimits  = [R6.LatitudeLimits(1) R1.LatitudeLimits(2)];        % Set latitude limits in geocellreference structure
    R.LongitudeLimits = [R1.LongitudeLimits(1) R6.LongitudeLimits(2)];      % Set longitude limits in geocellreference structure
    
    R.RasterSize = [size(A,1) size(A,2)];                                   % Set raster size in geocellreference structure
    
    latvec = flip(linspace(R.LatitudeLimits(1),R.LatitudeLimits(2),size(A,1)));% Generate vector of reference latitudes
    lonvec = linspace(R.LongitudeLimits(1),R.LongitudeLimits(2),size(A,2)); % Generate vector of reference longitudes
    
    latind(1) = find(latvec > latlim(2),1,'last');                          % Find last index in latvec outside of reference latitude
    latind(2) = find(latvec < latlim(1),1,'first');                         % Find first index in latvec outside of reference latitude
    
    lonind(1) = find(lonvec < lonlim(1),1,'last');                          % Find last index in lonvec outside of reference longitude
    lonind(2) = find(lonvec > lonlim(2),1,'first');                         % Find first index in lonvec outside of reference longitude
    
    A = A(latind(1):latind(2),lonind(1):lonind(2));                         % Retain only the data inside the lat/lon limits
    
    latnum = ceil((latlim(2) - latlim(1)) * CPD);                           % Find desired number of latitude cells inside geotiff data
    lonnum = ceil((abs(lonlim(1)) - abs(lonlim(2))) * CPD);                 % Find desired number of longitude cells inside geotiff data
    
    A = A(floor(linspace(1,size(A,1),latnum)),floor(linspace( ...           % Sample geotiff data with desired number of cells per degree of lat/lon
        1,size(A,2),lonnum)));
    R.RasterSize = [size(A,1),size(A,2)];                                   % Set raster size in geocellreference structure
    R.LatitudeLimits = latlim;                                              % Set latitude limits in geocellreference structure
    R.LongitudeLimits = lonlim;                                             % Set longitude limits in geocellreference structure
    
    A = double(A);                                                          % Convert values from int to double
    
    A(A == -9999) = NaN;                                                    % Convert water values to NaN
    A(A ==  9998) = 0;                                                      % Convert "no data" values to 0

    [dx,dy] = gradient(A);                                                  % Calculate gradient of elevations
    
    dx = abs(dx);                                                           % Take absolute value because it doesn't matter if the elevation is increasing or decreasing
    dy = abs(dy);                                                           % Take absolute value because it doesn't matter if the elevation is increasing or decreasing

    dx(dx > 10) = 1;                                                      % All values greater than 10 m over the quadrant are set to NaN
    dy(dy > 10) = 1;                                                      % All values greater than 10 m over the quadrant are set to NaN
    
    dx(dx ~= 1) = NaN;                                                     % All values less than 10 m over the quadrant are set to 1
    dy(dy ~= 1) = NaN;                                                     % All values less than 10 m over the quadrant are set to 1
%     dx(dx > 10) = NaN;                                                      % All values greater than 10 m over the quadrant are set to NaN
%     dy(dy > 10) = NaN;                                                      % All values greater than 10 m over the quadrant are set to NaN
%     
%     dx(~isnan(dx)) = 1;                                                     % All values less than 10 m over the quadrant are set to 1
%     dy(~isnan(dy)) = 1;                                                     % All values less than 10 m over the quadrant are set to 1
    
    A = A .* dx .* dy;                                                      % Preserve only areas with gradients less than 10 m in both x and y direction over the quadrant area
    
    A(A > 1) = 1;

    elev = A .* grid;                                                       % Retain only values within the borders of ConUS
    elevR = R;                                                              % Return geocellreference structure

end