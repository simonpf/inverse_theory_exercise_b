function [surf] = plot_gmi_swath(Z, orbit_index)
%plot_gmi_swath Plot modis RGB images.
%
% Plot data on the gmi swath.
% The swath index defines which of the two swaths should
% be plotted.
%
% Returns the surface handle for the plotted swath.
%

if nargin < 2
    orbit_index = 0;
end

data = load('data/plots/plots.mat', ... 
            'gmi_lats_0', ...
            'gmi_lons_0', ...
            'gmi_lats_1', ...
            'gmi_lons_1');

if orbit_index == 0;
    lats = data.gmi_lats_0;
    lons = data.gmi_lons_0;
else
    lats = data.gmi_lats_1;
    lons = data.gmi_lons_1;
end

usamap([5 50], [110 160]);
surf = geoshow(lats, lons, Z, 'DisplayType', 'TextureMap');

S = shaperead('landareas','UseGeoCoords',true);
geoshow([S.Lat], [S.Lon],'Color','black');
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8]);
set(gcf, 'Color', [1.0, 1.0, 1.0]);

end