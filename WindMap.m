function [wind,windR] = WindMap(CPD, latlim, lonlim, grid)
%WindMap processes geospatial wind speed data
%   Takes in unformatted geospatial wind speed data at 100 m above ground
%   level and filters out extraneous data by setting values to NaN

    addpath('/Users/stormmata/Downloads/TiffData');

    [A,R] = readgeoraster('WndSpd100m.tif');                                % Wind speed data at 100 m above ground level

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

    wind = A .* grid;                                                       % Retain only values within the borders of ConUS
    windR = R;                                                              % Return geocellreference structure

    fprintf('\n------------------------')                                   % Print completed function to screen
    fprintf('\n-------Wind Map---------')
    fprintf('\n------------------------\n')

end