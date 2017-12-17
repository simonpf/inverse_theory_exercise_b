function [img] = plot_modis()
%plot_modis Plot modis RGB images.
%
% Takes the modis images and fuses them into
% one single image since Matlab geoshow doesn't
% like transparency.

data = load('data/plots/plots.mat', ... 
            'modis_img_0', ...
            'modis_img_1', ...
            'modis_img_0_lats', ...
            'modis_img_0_lons');
img1 = data.modis_img_0;
img1_rgb = img1(1:end, 1:end, 1:3);
img2 = data.modis_img_1;
img2_rgb = img2(1:end, 1:end, 1:3);
lats = data.modis_img_0_lats;
lons = data.modis_img_0_lons;


img = ones(size(img1, 1), size(img1, 2), 3);
inds = repmat(~img1(1:end, 1:end, 4) == 0.0, 1, 1, 3);
img(inds) = img1_rgb(inds);
inds = repmat(~img2(1:end, 1:end, 4) == 0.0, 1, 1, 3);
img(inds) = img2_rgb(inds);

usamap([5 50], [110 160]);
img = geoshow(lats, lons, img);

S = shaperead('landareas','UseGeoCoords',true);
geoshow([S.Lat], [S.Lon],'Color','black');
geoshow('landareas.shp', 'FaceColor', [0.8 0.8 0.8]);
set(gcf, 'Color', [1.0, 1.0, 1.0]);
title('Modis RGB');

end

