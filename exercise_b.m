%%%
% Loading the data.
%%%
addpath('utils/matlab/');
load('data/matlab/exercise_b.mat');

%%%
% Histogram
%
% Apparently matlab doesn't accept the leftmost bin edge to be set
% to zero on a log scale, so we have to replace all zero values by
% small non-zero values to display them in a single histogram.
%%%

iwp = iwp_database;
iwp(iwp < 1e-10) = 1e-10;
bins = logspace(-11, 3, 21);

histogram(iwp, bins);
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlim([1e-11, bins(end)]);
xlabel('IWP [kg / m^2]');

%%%
% BMCI
%
% We just use the (B)MCI implementation from atmlab.
%%%

M  = struct;
Se = diag([0.32 0.31 0.7 0.65 0.56 0.47] .^ 2.0);

n_val = size(iwp_validation, 1);
x_mean = zeros(n_val, 1);
x_std  = zeros(n_val, 1);
x_log_mean = zeros(n_val, 1);
x_log_std  = zeros(n_val, 1);
mape   = zeros(n_val, 1);
mpe   = zeros(n_val, 1);
iwp_pred = zeros(n_val, 1);


%%%
% Running the retrieval on the validation set.
% This may take some time.
%%%

for i = 1:n_val
    [r, e] = mci(M, iwp_database', y_database', Se, y_validation(i, 1:end)');
    x_mean(i) = r;
    x_std(i)  = 100.0 * (e / r);
    mape(i)   = 100.0 * abs(r - iwp_validation(i)) / r;
    mpe(i)    = 100.0 * (r - iwp_validation(i)) / r;
    iwp_pred(i) = r;
    disp(i);
end

%%%
% MAPE
%%%

n_bins = 20;
x_l = -5;
x_u = 1;
xs  = logspace(x_l, x_u, n_bins + 1);
xs_centers = 0.5 * (xs(2 : end) + xs(1 : end - 1));
ys_mape = zeros(1, n_bins);
ys_mpe  = zeros(1, n_bins);
ys_std  = zeros(1, n_bins);
for i = 1 : n_bins
    inds  = (iwp_pred >= xs(i)) & (iwp_pred < xs(i + 1));
    ys_mape(i) = nanmean(mape(inds));
    ys_mpe(i)  = nanmean(mpe(inds));
    ys_std(i)  = nanmean(x_std(inds));
end

figure
subplot(1, 2, 1);
hold on;
plot(xs_centers, ys_mape, 'r');
plot(xs_centers, ys_std, 'b');
set(gca, 'XScale', 'log');
set(gca, 'YScale', 'log');
xlabel('IWP [kg / m^2]');
ylabel('Error [%]');
legend('MAPE', 'Std. Dev.');
title('MAPE & Std. Dev.');

subplot(1, 2, 2);
plot(xs_centers, ys_mpe);
set(gca, 'XScale', 'log');
set(gca, 'YLim', [-1000.0, 1000.0]);
xlabel('IWP [kg / m^2]');
ylabel('Error [%]');
title('MPE');

%%%
% CDF
%%%

[ignored, inds] = sort(iwp_validation);

i = inds(30001);
[ignored, inds] = sort(iwp_database);
[r, e, d, ws] = mci(M, iwp_database', y_database', Se, y_validation(i, 1:end)');

figure
norm = sum(ws);
plot(iwp_database(inds), cumsum(ws(inds)) / norm);
set(gca, 'XScale', 'log');
xlabel('IWP [kg / m^2]');
title('Posterior CDF');

%%%
% GMI Retrieval
%%%

n_lons = size(gmi_tbs_0, 1);
n_lats = size(gmi_tbs_0, 2);

iwp_mean   = zeros(n_lons, n_lats);
iwp_median = zeros(n_lons, n_lats); 
iwp_10_p   = zeros(n_lons, n_lats);
[iwp_sorted, inds] = sort(iwp_database);

for i = 1:n_lons
    display(i);
    for j = 1:n_lats
        [r, e, d, ws] = mci(M, iwp_database', y_database', Se, ...
                            reshape(gmi_tbs_0(i, j, 1:end), 6, 1));
        iwp_mean(i, j) = r;
        norm = sum(ws);
        qs = interp1q(cumsum(ws(inds)) / norm, iwp_sorted, [0.1; 0.5]);
        iwp_median(i, j) = qs(2);
        iwp_10_p(i, j)   = qs(1);
    end
end

subplot(2, 2, 1);
plot_modis();
% gmi_tbs_0 -> swath_index = 0

subplot(2, 2, 2);
iwp = max(iwp_mean, 1e-3);
title('Mean');
plot_gmi_swath(log(iwp), 0);
colorbar();

subplot(2, 2, 3);
title('Median');
iwp = max(iwp_median, 1e-3);
plot_gmi_swath(log(iwp), 0);
colorbar();

subplot(2, 2, 4);
title('10th Percentile');
iwp = max(iwp_10_p, 1e-3);
plot_gmi_swath(log(iwp), 0);
colorbar();







        