%% Load and wind speeds at 120 meters
addpath('/Users/stormmata/Library/Mobile Documents/com~apple~CloudDocs/Courses/Spring 2021/1.001/Project');

data120m    = readmatrix('Open_Access_Siting_Regime_ATB_Mid_Turbine.csv');

%% Process and plot wind speeds at 120 meters

% Extract data from array
    lats    = data120m(2:end,2);
    longs   = data120m(2:end,3);
    wndspd  = data120m(2:end,8);

% Construct grid
    [xq,yq] = meshgrid(25:0.25:51, -125:0.25:-65);

% Interpolate
    z       = griddata(lats,longs,wndspd,xq,yq);

% Construct map axes for US
    ax      = usamap('conus');
    set(ax, 'Visible', 'off')
    latlim  = getm(ax, 'MapLatLimit');
    lonlim  = getm(ax, 'MapLonLimit');
    states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', ...
                        [lonlim', latlim']);
    tightmap

% Different way of constructing map axes
    % worldmap([25 51],[-125 -65]);
    % load coastlines
    % plotm(coastlat,coastlon)
    % geoshow(coastlat,coastlon)

% Contour map layer
    [~,h] = contourfm(xq,yq,z,15,'linecolor','none');
    c = colorbar;
    c.Label.String = 'Wind Speed (m/s)';
    caxis([3 10]);

% Set alpha of contour
    set(gcf, 'Renderer', 'OpenGL');
    alphable = findobj(h, '-property', 'FaceAlpha');
    set(alphable, 'FaceAlpha', 0.9);


% Add state borders
    geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1.5)

title('Wind Speed at 120 m')

%% Process and plot wind resource at 120 meters

r   = 60;         % m
rho = 1.225;    % kg/m^3
A   = pi * r^2;    % m^2

P   = 0.5 * rho * A .* z.^3;

P = P./1e6;

% Construct map axes for US
    ax      = usamap('conus');
    set(ax, 'Visible', 'off')
    latlim  = getm(ax, 'MapLatLimit');
    lonlim  = getm(ax, 'MapLonLimit');
    states  = shaperead('usastatehi','UseGeoCoords', true, 'BoundingBox', ...
                        [lonlim', latlim']);
    tightmap

% Contour map layer
    [~,h] = contourfm(xq,yq,P,15,'linecolor','none');
    c = colorbar;
    c.Label.String = 'Power (MW)';
    caxis([1 5]);


% Set alpha of contour
    set(gcf, 'Renderer', 'OpenGL');
    alphable = findobj(h, '-property', 'FaceAlpha');
    set(alphable, 'FaceAlpha', 0.9);

% Add state borders
    geoshow(ax, states, 'FaceColor', [1 1 1],'FaceAlpha',0,'LineWidth',1.5)

title('Wind Resource at 120 m')

%% Plot wind farm locations

wndfarms = jsondecode(fileread('wind_prospector-windpro_windfarms_icon.json'));

wflats   = zeros(length(wndfarms.features),1);
wflongs  = zeros(length(wndfarms.features),1);

for i = 1:length(wndfarms.features)
    wflats(i)   = wndfarms.features(i).geometry.coordinates(2);
    wflongs(i)  = wndfarms.features(i).geometry.coordinates(1);
end

fprintf('\nIndex:     ')

for i = 1:length(wflongs)

    plotm(wflats(i),wflongs(i),'marker','o','markersize',5,'color','k','markerfacecolor','#fc4903','MarkerEdgeColor','none')
    
    fprintf('\b\b\b\b\b%5.0f',i)                                  % Let me know it's working

end