import numpy as np
import utils.setup
import matplotlib.pyplot as plt

##########################################################################################
# Inverse Theory - Exercise B
##########################################################################################

#
# Loading the data
#
y_database   = np.load("data/python/y_database.npy")
iwp_database = np.load("data/python/iwp_database.npy")


#
# Plotting the distribution in a nice way is bit tricky
# because it spans several orders of magnitude but also
# 0.0. To circumvent this you can either
#
# - Create log-spaced histogram bins yourself and set the
#   leftmost to zero.
# - Replace zero values with a very small non-zero value.


#
# Tropical Storm Saola
#

from utils.plots import plot_modis_image, plot_gmi_swath
from matplotlib.colors import LogNorm

# The plot_modis_image and plot_gmi_swath functions are
# provided to simplify plotting of your retrieval results.
#
# Your retrieval will contian a lot of very small values
# to avoid them from messing up the scale and also because
# the IWP values span several orders of magnitude, it's
# a good idea to use a custom log-norm for all plots.

norm = LogNorm(vmin = 1e-3, vmax = 100.0)
f, axs = plt.subplots(2, 2, figsize = (8, 8))


plot_modis_image(ax = axs[0, 0])
axs[0, 0].set_title("Modis RGB")

# Mean IWP
im = plot_gmi_swath(iwp_mean, orbit_index = 0, ax = axs[0, 1], norm = norm)
axs[0, 1].set_title("Mean")

# Median
plot_gmi_swath(iwp_median, orbit_index = 0, ax = axs[1, 0], norm = norm)
axs[1, 0].set_title("Median")

# Median
plot_gmi_swath(iwp_10_p, orbit_index = 0, ax = axs[1, 0], norm = norm)
axs[1, 0].set_title("10th Percentile")

plt.colorbar(im, ax = axs.ravel().tolist())
