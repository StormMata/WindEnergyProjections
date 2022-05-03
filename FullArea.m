function [grid,gridR] = FullArea(CPD, latlim, lonlim)
%FullArea processes geospatial data showing the full extent of the
%Continental US
%   Takes in unformatted geospatial agricultural development data and
%   filters out extraneous data by setting values to NaN, and sets all
%   values to 1 to show the full extent of the US as a reference for
%   calculating the available area within the US

    addpath('/Users/stormmata/Downloads/TiffData');
    
    grid = zeros((latlim(2) - latlim(1)) * CPD,(abs(lonlim(1)) ...          % Preallocate full US grid
           - abs(lonlim(2))) * CPD);
    
    latvec = flip(linspace(latlim(1),latlim(2),size(grid,1)));              % Generate vector of reference latitudes
    lonvec = linspace(lonlim(1),lonlim(2),size(grid,2));                    % Generate vector of reference longitudes

    for i = 1:31
    
        [A,R] = readgeoraster(sprintf('Crops-%1.0f.tif',i));                % Import raw geotif data
    
        latnum = ceil((R.LatitudeLimits(2) - R.LatitudeLimits(1)) * CPD);   % Find desired number of latitude cells inside geotiff data
        lonnum = ceil((abs(R.LongitudeLimits(1)) - abs( ...                 % Find desired number of longitude cells inside geotiff data
                 R.LongitudeLimits(2))) * CPD);
        
        A = A(floor(linspace(1,size(A,1),latnum)),floor(linspace( ...       % Sample geotiff data with desired number of cells per degree of lat/lon
            1,size(A,2),lonnum)));
        R.RasterSize = [size(A,1),size(A,2)];                               % Set raster size in geocellreference structure
    
        A = double(A);                                                      % Convert values from int to double
    
        A(A > 0) = 1;                                                       % Convert all non-zeros values to 1
    
        latind = find(latvec > R.LatitudeLimits(2),1,'last');               % Find last index in latvec outside of reference latitude
        lonind = find(lonvec < R.LongitudeLimits(1),1,'last');              % Find last index in lonvec outside of reference longitude
    
        grid(latind:(latind - 1 + size(A,1)),lonind:(lonind - 1 + ...       % Insert geotiff data into full US grid
            size(A,2))) = grid(latind:(latind - 1 + size(A,1)),lonind: ...
            (lonind - 1 + size(A,2))) + A;
    
    end
    
    gridR = R;                                                              % Duplicate geocellreference structure
    gridR.LatitudeLimits  = [latvec(end) latvec(1)];                        % Set latitude limits in geocellreference structure
    gridR.LongitudeLimits = [lonvec(1) lonvec(end)];                        % Set longitude limits in geocellreference structure
    gridR.RasterSize      = [size(grid,1) size(grid,2)];                    % Set raster size in geocellreference structure

    grid = imfill(grid,'holes');                                            % Fills holes from piecing together geotif files
    
    grid(grid == 0) = NaN;                                                  % Convert all 0s to NaN 
    grid(grid > 1)  = 1;                                                    % Reset all nonzeros values to 1

    fprintf('\n------------------------')                                   % Print completed function to screen
    fprintf('\n-------Full Area--------')
    fprintf('\n------------------------\n')

end