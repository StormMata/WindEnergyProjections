function [forest,forestR] = ForestArea(CPD, latlim, lonlim, grid)
%ForestArea processes geospatial vegetation data
%   Takes in unformatted geospatial vegetation data (0-100 in percent 
%   vegetation coverage )and filters out extraneous data by setting values
%   to NaN

    addpath('/Users/stormmata/Downloads/TiffData');
    
    [A1,R1] = readgeoraster('Forest-C1.tif');                               % Panel: Column 1
    [A2,R2] = readgeoraster('Forest-C2.tif');                               % Panel: Column 2
    
    A = [A1,A2];                                                            % Combine all panels
    
    R = R1;                                                                 % Generate geocellreference structure

    R.LongitudeLimits(2) = R2.LongitudeLimits(2);                           % Set longitude limits in geocellreference structure
    
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
    
    A(A == 254) = NaN;                                                      % Convert water values to NaN
    A(A == 255) = NaN;                                                      % Convert "no data" values to 0
    
    A(A < 10) = NaN;                                                        % Set values below 10% vegetation coverage to NaN
    A(A >= 10) = 1;                                                         % Set all values above 10% vegetation coverage to 1
    
    forest = A .* grid;                                                     % Retain only values within the borders of ConUS
    forestR = R;                                                            % Return geocellreference structure

end