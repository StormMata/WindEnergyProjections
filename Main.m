clc
clearvars

addpath('/Users/stormmata/Library/Mobile Documents/com~apple~CloudDocs/Courses/2021 Spring/1.001/Project');

addpath('/Users/stormmata/Downloads');


[grid,gridR]     = FullArea(150);

[crops,cropsR]   = CropArea(150);

[water,waterR]   = WaterArea(150);

[city,cityR]     = CityArea(150);

[forest,forestR] = ForestArea(150);

[Elev,ElevR]     = ElevationMap(150);

grid = grid(floor(linspace(1,size(grid,1),500)),floor(linspace(1,size(grid,2),1000)));
gridR.RasterSize = [size(grid,1),size(grid,2)];

crops = crops(floor(linspace(1,size(crops,1),500)),floor(linspace(1,size(crops,2),1000)));
cropsR.RasterSize = [size(crops,1),size(crops,2)];

water = water(floor(linspace(1,size(water,1),500)),floor(linspace(1,size(water,2),1000)));
waterR.RasterSize = [size(water,1),size(water,2)];

latlim  = [23,50];
lonlim  = [-127,-65];

figure;
    ax      = usamap('conus');
    set(ax, 'Visible', 'off')
    states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', ...
                        [lonlim', latlim']);


    geoshow(ax,comb,gridR,'displaytype', 'surface');


%     contourfm(grid,gridR,'linecolor','none')
%     contourfm(crops,cropsR,'linecolor','none')
    contourfm(water,waterR,'linecolor','none')