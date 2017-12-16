import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.basemap import Basemap
from matplotlib.colors import LogNorm

def plot_modis_image(ax = None):

    lon_ll, lat_ll, lon_ur, lat_ur = np.load("data/plots/region_latlon.npy")
    print((lon_ll, lat_ll, lon_ur, lat_ur))
    x_ll, y_ll, x_ur, y_ur         = np.load("data/plots/region_xy.npy")
    print((x_ll, y_ll, x_ur, y_ur))
    lon_0 = 0.5 * (lon_ll + lon_ur)
    lat_0 = 0.5 * (lat_ll + lat_ur)
    m = Basemap(projection = 'ortho',
                lon_0 = lon_0,
                lat_0 = lat_0,
                llcrnrx = x_ll,
                llcrnry = y_ll,
                urcrnrx = x_ur,
                urcrnry = y_ur,
                resolution = "l",
                ax = ax)

    if ax is None:
        ax = plt.gca()

    for i in range(2):
        z   = np.load("data/plots/modis_img_" + str(i) + ".npy")
        ext = np.load("data/plots/modis_img_" + str(i) + "_extent.npy")
        img = ax.imshow(z, origin = "lower",
                        extent = ext.tolist())
    m.drawparallels(np.linspace(10, 40, 4))
    m.drawmeridians(np.linspace(120, 150, 4))
    m.drawcoastlines()
    m.fillcontinents(color='grey')
    ax.set_xlim([x_ll, x_ur])
    ax.set_ylim([y_ll, y_ur])

def plot_gmi_swath(orbit = 0, channel = 0, ax = None, **kwargs):

    lon_ll, lat_ll, lon_ur, lat_ur = np.load("data/plots/region_latlon.npy")
    x_ll, y_ll, x_ur, y_ur         = np.load("data/plots/region_xy.npy")
    lon_0 = 0.5 * (lon_ll + lon_ur)
    lat_0 = 0.5 * (lat_ll + lat_ur)
    m = Basemap(projection = 'ortho',
                lon_0 = lon_0,
                lat_0 = lat_0,
                llcrnrx = x_ll,
                llcrnry = y_ll,
                urcrnrx = x_ur,
                urcrnry = y_ur,
                resolution = "l",
                ax = ax)

    if ax is None:
        ax = plt.gca()

    lons = np.load("data/plots/gmi_lons_" + str(orbit) + ".npy")
    lats = np.load("data/plots/gmi_lats_" + str(orbit) + ".npy")
    data = np.load("data/python/gmi_tbs_" + str(orbit) + ".npy")

    x, y = m(lons, lats)

    img = ax.pcolormesh(x, y, data[:, :, channel], **kwargs)
    m.drawparallels(np.linspace(10, 40, 4))
    m.drawmeridians(np.linspace(120, 150, 4))
    m.drawcoastlines()
    m.fillcontinents(color='grey')
    ax.set_xlim([x_ll, x_ur])
    ax.set_ylim([y_ll, y_ur])

    return img

def plot_iwp(iwp, iwp_min = 1e-6):

    f, axs = plt.subplots(1, 2, figsize = (10, 6))
    plot_modis_image(ax = axs[0])

    lon_ll, lat_ll, lon_ur, lat_ur = np.load("data/plots/region_latlon.npy")
    x_ll, y_ll, x_ur, y_ur         = np.load("data/plots/region_xy.npy")
    lon_0 = 0.5 * (lon_ll + lon_ur)
    lat_0 = 0.5 * (lat_ll + lat_ur)
    m = Basemap(projection = 'ortho',
                lon_0 = lon_0,
                lat_0 = lat_0,
                llcrnrx = x_ll,
                llcrnry = y_ll,
                urcrnrx = x_ur,
                urcrnry = y_ur,
                resolution = "l",
                ax = axs[1])

    lons = np.load("data/gmi_lons_0.npy")
    lats = np.load("data/gmi_lats_0.npy")
    n_lons = lons.shape[1]
    n_lats = lons.shape[0]

    x, y = m(lons, lats)

    iwp[iwp < iwp_min] = np.float('nan')
    img = axs[1].pcolormesh(x, y, iwp.reshape(n_lats, n_lons), norm = LogNorm())
    m.drawparallels(np.linspace(10, 40, 4))
    m.drawmeridians(np.linspace(120, 150, 4))
    m.drawcoastlines()
    m.fillcontinents(color='grey')
    axs[1].set_xlim([x_ll, x_ur])
    axs[1].set_ylim([y_ll, y_ur])

    f.colorbar(img, ax = axs.ravel().tolist(),
               label = "IWP [$kg/m^2$]", fraction = 0.046, pad = 0.04)

    return img

def mape(iwp_pred, iwp_test):
    return 100.0 * np.abs(iwp_pred - iwp_test) / iwp_pred

def plot_errors(iwp_pred, iwp_pred_std, iwp_test):

    f, axs = plt.subplots(1, 2, figsize = (10, 6))

    bins = np.logspace(-5, 1, 11)
    mapes = np.zeros(bins.size - 1)
    stds  = np.zeros(bins.size - 1)

    for i in range(10):
        x_l = bins[i]
        x_r = bins[i + 1]

        inds = (iwp_pred >= x_l) * (iwp_pred < x_r)
        mapes[i] = np.mean(mape(iwp_pred[inds], iwp_test[inds]))
        stds[i] = 100.0 * np.mean(iwp_pred_std[inds] / iwp_pred[inds])

    x = 0.5 * (bins[1:] + bins[:-1])

    axs[0].plot(x, mapes)
    axs[0].set_xlabel("IWP $[kg / m^2]$")
    axs[0].set_ylabel("MAPE [%]")
    axs[0].set_xscale("log")
    axs[0].set_yscale("log")
    axs[0].set_ylim([1e1, 1e5])

    axs[1].plot(x, stds)
    axs[1].set_xlabel("IWP $[kg / m^2]$")
    axs[1].set_ylabel("Retrieval Uncertainty [%]")
    axs[1].set_xscale("log")
    axs[1].set_yscale("log")
    axs[1].set_ylim([1e1, 1e5])
