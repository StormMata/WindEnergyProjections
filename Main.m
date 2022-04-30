clc
clearvars

addpath('/Users/stormmata/Library/Mobile Documents/com~apple~CloudDocs/Courses/2021 Spring/1.001/Project');

addpath('/Users/stormmata/Downloads');

latlim  = [23,50];                                                          % Latitude limits for bounding box
lonlim  = [-127,-65];                                                       % Longitude limits for bounding box

[grid,gridR]     = FullArea(150, latlim, lonlim);

[crops,cropsR]   = CropArea(150, latlim, lonlim);

[water,waterR]   = WaterArea(150, latlim, lonlim);

[city,cityR]     = CityArea(150, latlim, lonlim);

[forest,forestR] = ForestArea(150, latlim, lonlim, grid);

[elev,elevR]     = ElevationMap(150, latlim, lonlim, grid);

[comb]           = CombineAreas(crops,water,city,forest,elev);

% grid = grid(floor(linspace(1,size(grid,1),500)),floor(linspace(1,size(grid,2),1000)));
% gridR.RasterSize = [size(grid,1),size(grid,2)];
% 
% crops = crops(floor(linspace(1,size(crops,1),500)),floor(linspace(1,size(crops,2),1000)));
% cropsR.RasterSize = [size(crops,1),size(crops,2)];
% 
% water = water(floor(linspace(1,size(water,1),500)),floor(linspace(1,size(water,2),1000)));
% waterR.RasterSize = [size(water,1),size(water,2)];

figure;
    ax      = usamap('conus');
    set(ax, 'Visible', 'off')
    states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', ...
                        [lonlim', latlim']);

    geoshow(ax,comb,gridR,'displaytype', 'surface');
    geoshow(ax,grid,gridR,'displaytype', 'surface');
    geoshow(ax,crops,cropsR,'displaytype', 'surface');
    geoshow(ax,water,waterR,'displaytype', 'surface');
    geoshow(ax,city,cityR,'displaytype', 'surface');
    geoshow(ax,forest,forestR,'displaytype', 'surface');
    geoshow(ax,elev,elevR,'displaytype', 'surface');

    geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1.5)

%     colormap([0 102/255 0;1 1 0;51/255 51/255 255/255;75/255 75/255 75/255])
    colormap([0 102/255 0;235/255 198/255 52/255;51/255 51/255 255/255;75/255 75/255 75/255;168/255 52/255 235/255])

    colormap([forestRGB;elevRGB;waterRGB;cropRGB;cityRGB])

cropRGB   = [252 164  56]/255;
waterRGB  = [52  128 235]/255;
cityRGB   = [191  10  10]/255;
forestRGB = [45  145  44]/255;
elevRGB   = [195  76 224]/255;

%     contourfm(grid,gridR,'linecolor','none')
%     contourfm(crops,cropsR,'linecolor','none')
    contourfm(water,waterR,'linecolor','none')