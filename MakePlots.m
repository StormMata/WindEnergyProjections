function MakePlots(grid,wind,crops,water,city,forest,elev,comb,combW,gridR)
%MakePlots generates plots for map layers
%   Takes in the constituent map layers for this project and generates
%   plots for illustration and the final presentation

% ------------------------------ Preliminary ------------------------------

    cropRGB   = [252 164  56]/255;
    waterRGB  = [52  128 235]/255;
    cityRGB   = [191  10  10]/255;
    forestRGB = [45  145  44]/255;
    elevRGB   = [195  76 224]/255;

    set(0,'DefaultFigureColor',[1 1 1])

% ------------------------------ Full US Map ------------------------------

    FullFig = figure;
        FullAx      = usamap('conus');
        set(FullAx, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(FullAx,grid,gridR,'displaytype', 'surface');
        geoshow(FullAx, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)

% ------------------------ Wind Speed at 100 m Map ------------------------

    figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,wind,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap(parula)
        caxis([3 10])

% ---------------------- Agricultural Development Map ---------------------

    CropFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,crops,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([cropRGB])
        view(ax,0,25)
        set(CropFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(CropFig).cdata, 'crops.png', 'png', 'transparency', [1 1 1])

% --------------------------- Standing Water Map --------------------------

    WaterFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,water,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([waterRGB])
        view(ax,0,25)
%         set(gcf, 'color', 'none');   
%         set(gca, 'color', 'none');
%         exportgraphics(gca,'water.eps','ContentType','vector')
%         exportgraphics(gca,'water.png','ContentType','vector','BackgroundColor','none')
%         exportgraphics(gca,'water.eps','ContentType','vector','BackgroundColor',[1 1 1])
        set(WaterFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(WaterFig).cdata, 'water.png', 'png', 'transparency', [1 1 1])

% ------------------------- Urban Development Map -------------------------

    CityFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,city,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([cityRGB])
        view(ax,0,25)
        set(CityFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(CityFig).cdata, 'city.png', 'png', 'transparency', [1 1 1])

% -------------------------- Forest Coverage Map --------------------------

    ForestFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,forest,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([forestRGB])
        view(ax,0,25)
        set(ForestFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(ForestFig).cdata, 'forest.png', 'png', 'transparency', [1 1 1])

% --------------------- Elevation Map and Gradient Map --------------------

    ElevFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,elev,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([elevRGB])
        view(ax,0,25)
        set(ElevFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(ElevFig).cdata, 'elev.png', 'png', 'transparency', [1 1 1])

% --------------------------- Combined Layer Map --------------------------

    CombFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,comb,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([forestRGB;elevRGB;waterRGB;cropRGB;cityRGB])
        view(ax,0,25)
        set(CombFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(CombFig).cdata, 'combinedUnSC32.png', 'png', 'transparency', [1 1 1])

    addpath('/Users/stormmata/Downloads/github_repo');

        gif('combined.gif','resolution',150,'loopcount',1)
        for i = 26:90
            view(ax,0,i)
            gif
        end

    figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);
        geoshow(ax,combW,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)


end