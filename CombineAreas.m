function [comb,combR] = CombineAreas(forest,forestR,crops,cropsR,water,waterR,city,cityR)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

crops(isnan(crops)) = 0;
water(isnan(water)) = 0;
city(isnan(city))   = 0;



comb = forest .* grid;

comb(crops == 1) = 2;

comb(water == 1) = 3;

comb(city == 1) = 4;

comb(comb == 0) = NaN;

comb = comb(floor(linspace(1,size(comb,1),300)),floor(linspace(1,size(comb,2),600)));
combR = cropsR;
combR.RasterSize = [size(comb,1),size(comb,2)];

latlim  = [23,50];
lonlim  = [-127,-65];

figure;
    ax      = usamap('conus');
    set(ax, 'Visible', 'off')
    states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', ...
                        [lonlim', latlim']);

%     contourfm(comb,combR,'linecolor','none')

%     colormap([0 102/255 0;1 1 0;51/255 51/255 255/255;75/255 75/255 75/255])
    colormap([0 102/255 0;1 128/255 0;51/255 51/255 255/255;75/255 75/255 75/255])


    geoshow(ax,comb,gridR,'displaytype', 'surface');
    geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1.5)



addpath('/Users/stormmata/Downloads/GlobalMountainsK3Binary');

[A,R] = readgeoraster('k3binary.tif');

end