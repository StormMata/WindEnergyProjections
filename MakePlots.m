function MakePlots(grid,wind,crops,water,city,forest,elev,comb,combW,gridR,latlim, lonlim)
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

    states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', [lonlim', latlim']);

% ------------------------------ Full US Map ------------------------------

    FullFig = figure;
        FullAx      = usamap('conus');
        set(FullAx, 'Visible', 'off')
        geoshow(FullAx,grid,gridR,'displaytype', 'surface');
        geoshow(FullAx, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)

% ------------------------ Wind Speed at 100 m Map ------------------------

    WindFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,wind,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap(parula)
        caxis([3 10])
        c = colorbar;
        c.Label.String = 'Wind Speed (m/s)';

% ---------------------- Agricultural Development Map ---------------------

    CropFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,crops,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([cropRGB])
%         view(ax,0,25)
%         set(CropFig,'units','inches','position',[0,0,20,10])
%         imwrite(getframe(CropFig).cdata, 'cropsF.png', 'png', 'transparency', [1 1 1])

% --------------------------- Standing Water Map --------------------------

    WaterFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,water,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([waterRGB])
%         view(ax,0,25)
%         set(WaterFig,'units','inches','position',[0,0,20,10])
%         imwrite(getframe(WaterFig).cdata, 'waterF.png', 'png', 'transparency', [1 1 1])

% ------------------------- Urban Development Map -------------------------

    CityFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,city,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([cityRGB])
%         view(ax,0,25)
%         set(CityFig,'units','inches','position',[0,0,20,10])
%         imwrite(getframe(CityFig).cdata, 'cityF.png', 'png', 'transparency', [1 1 1])

% -------------------------- Forest Coverage Map --------------------------

    ForestFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,forest,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        c = colorbar;
        c.Label.String = 'Percent Vegetation';
        colormap([forestRGB])
%         view(ax,0,25)
%         set(ForestFig,'units','inches','position',[0,0,20,10])
%         imwrite(getframe(ForestFig).cdata, 'forest.png', 'png', 'transparency', [1 1 1])

% --------------------- Elevation Map and Gradient Map --------------------

    ElevFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,elev,gridR,'displaytype', 'surface');
        geoshow(ax,states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        c = colorbar;
        c.Label.String = 'Elevation (m)';
        caxis([0 3000])
        colormap([elevRGB])
%         view(ax,0,25)
%         set(ElevFig,'units','inches','position',[0,0,20,10])
%         imwrite(getframe(ElevFig).cdata, 'elev.png', 'png', 'transparency', [1 1 1])

% --------------------------- Combined Layer Map --------------------------

    CombFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,comb,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap([forestRGB;elevRGB;waterRGB;cropRGB;cityRGB])
        view(ax,0,25)
        set(CombFig,'units','inches','position',[0,0,20,10])
        imwrite(getframe(CombFig).cdata, 'combinedUnSC32.png', 'png', 'transparency', [1 1 1])

    CombWFig = figure;
        ax      = usamap('conus');
        set(ax, 'Visible', 'off')
        geoshow(ax,combW,gridR,'displaytype', 'surface');
        geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
        colormap(parula)
        set(CombWFig,'units','inches','position',[0,0,20,10])
        caxis([3 10])
        c = colorbar;
        c.Label.String = 'Wind Speed (m/s)';

% ------------------------ Capacity Simulation Gifs -----------------------

%     years = 2022:2080;
% 
%     for i = 1:length(years)
%         caps(i) = Outputs.(sprintf('NewCap%4.0f',years(i)));            % Extract capacity values
%     end
% 
%     for i = 1:length(years)
%         preds(i) = Outputs.(sprintf('PredCap%4.0f',years(i)));            % Extract predicted   capacity values
%     end
% 
%     capanimation = interp1(2022:2080,caps,2022:0.1:2080, "makima","extrap");
%     predanimation = interp1(2022:2080,preds,2022:0.1:2080, "makima","extrap");
%     
%     timeax = 2022:0.1:2080;
%     
%     figure;
%         hold on
%         ylim([0 50])
%         xlim([2020 2080])
%         ylabel('Annual New Capacity (GW)')
%         set(gca,'FontSize',16)
%         set(gca,'linewidth',2)
%         set(gcf,'units','inches','position',[0,0,20,10])
%         box on
%     gif('capacity.gif')
%     
%     for i = 1:length(capanimation)
%         plot(timeax(1:i),capanimation(1:i),'k','LineWidth',2)
%         plot(timeax(1:i),predanimation(1:i),'r','LineWidth',2)
%         legend('New Capacity','Predicted New Capacity','location','northwest')
%         gif
%     end

% ------------------------ Wind Farm Location Gifs ------------------------

%     CombWFig = figure;
%         ax      = usamap('conus');
%         set(ax, 'Visible', 'off')
%         geoshow(ax,combW,gridR,'displaytype', 'surface');
%         geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1)
%         colormap(parula)
%         caxis([3 10])
%         set(gca,'FontSize',16)
%         hold on
%     gif('farms.gif')
% 
%     for i = 1:length(years)
%         title(sprintf('%4.0f',years(i)))
%         points = Outputs.(sprintf('Coords%4.0f',years(i)));            % Extract predicted   capacity values
% 
%         for j = 1:size(points,1)
%             scatterm(latvec(points(j,1)),lonvec(points(j,2)),'r','filled','markeredgecolor','none','sizedata',15)
%             gif
%         end
%         clear points
%     end

end