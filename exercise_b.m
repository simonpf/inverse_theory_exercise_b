%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inverse Theory - Exercise B
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%
% Loading the data and helper functions.
%%%

addpath('utils/matlab/');
load('data/matlab/exercise_b.mat');

%%%
%
% Plotting the distribution in a nice way is bit tricky
% because it spans several orders of magnitude but also
% 0.0. To circumvent this you can replace zero values with
% a very small non-zero value.
%
%%%

%%%
%
% Tropical Storm Saola
%
% The plot_modis and plot_gmi_swath functions are provided to plot the
% MODIS image and your IWP retrieval results, respectively.
%
% Your retrieval will contain a lot of very small values.
% To avoid them from messing up the color scale it's a good idea
% to restrict the range of values plotted to significant IWP
% values.
%
% You also need to pass the index of the GMI orbit
% to the plot functions according to whether
% you computed the IWP for gmi_tbs_0 (orbit_index = 0)
% or gmi_tbs_1 (orbit_index = 1).
%
%%%


subplot(2, 2, 1);
plot_modis();

% Mean
subplot(2, 2, 2);
iwp = max(iwp_mean, 1e-3);
title('Mean');
% Plotting IWP for gmi_tbs_0.
plot_gmi_swath(log(iwp), 0);
colorbar();

% Median
subplot(2, 2, 3);
title('Median');
iwp = max(iwp_median, 1e-3);
% Plotting IWP for gmi_tbs_0.
plot_gmi_swath(log(iwp), 0);
colorbar();

subplot(2, 2, 4);
title('10th Percentile');
iwp = max(iwp_10_p, 1e-3);
% Plotting IWP for gmi_tbs_0.
plot_gmi_swath(log(iwp), 0);
colorbar();
