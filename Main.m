% -------------------------------------------------------------------------
% Main file for processing data and running simulation
%
% Instructions:
%   Run the following functions sequentially. They will load, process, and
%   plot the data. The final function will use the information to run a
%   simulation over the time horizon 2022-2080 for new wind capacity for
%   the United States.
% -------------------------------------------------------------------------

clc

clearvars

addpath('/Users/stormmata/Downloads');                                      % Set path to tiff data

latlim  = [  23, 50];                                                       % Latitude limits for bounding box
lonlim  = [-127,-65];                                                       % Longitude limits for bounding box

[grid,gridR]     = FullArea(150, latlim, lonlim);                           % Process reference background data for full US area

[wind,windR]     = WindMap(150, latlim, lonlim, grid);                      % Process wind speed measurements at 110-m above ground level

[crops,cropsR]   = CropArea(150, latlim, lonlim);                           % Process agricultural development data

[water,waterR]   = WaterArea(150, latlim, lonlim);                          % Process water area data

[city,cityR]     = CityArea(150, latlim, lonlim);                           % Process urban development data

[forest,forestR] = ForestArea(150, latlim, lonlim, grid);                   % Process forest area data

[elev,elevR]     = ElevationMap(150, latlim, lonlim, grid);                 % Process geospatial elevation data

[comb,combW]     = CombineAreas(wind,crops,water,city,forest,elev);         % Combine map layers

[Lats,Lons]      = SumArea(grid, gridR, combW);                             % Find remaining areas available for wind farm development

[Outputs]        = PowerCalcs(Lons,Lats,lonvec,latvec);                     % Simulate new wind farm development