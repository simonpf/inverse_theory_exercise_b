#!/bin/bash

WGT="wget -nv"
SRVR=http://spfrnd.de/data/inverse_theory_exercise_b/

mkdir data
mkdir data/python
cd data/python
${WGT} ${SRVR}data/python/gmi_tbs_0.npy
${WGT} ${SRVR}data/python/gmi_tbs_1.npy
${WGT} ${SRVR}data/python/iwp_database.npy
${WGT} ${SRVR}data/python/iwp_validation.npy
${WGT} ${SRVR}data/python/y_database.npy
${WGT} ${SRVR}data/python/y_validation.npy

cd ..
mkdir matlab
cd matlab

${WGT} ${SRVR}data/matlab/exercise_b.mat

cd ..
mkdir plots
cd plots

${WGT} ${SRVR}data/plots/gmi_lats_0.npy
${WGT} ${SRVR}data/plots/gmi_lats_1.npy
${WGT} ${SRVR}data/plots/gmi_lons_0.npy
${WGT} ${SRVR}data/plots/gmi_lons_1.npy
${WGT} ${SRVR}data/plots/modis_img_0.npy
${WGT} ${SRVR}data/plots/modis_img_0_lats.npy
${WGT} ${SRVR}data/plots/modis_img_0_lons.npy
${WGT} ${SRVR}data/plots/modis_img_0_extent.npy
${WGT} ${SRVR}data/plots/modis_img_1.npy
${WGT} ${SRVR}data/plots/modis_img_1_lats.npy
${WGT} ${SRVR}data/plots/modis_img_1_lons.npy
${WGT} ${SRVR}data/plots/modis_img_1_extent.npy
${WGT} ${SRVR}data/plots/region_latlon.npy
${WGT} ${SRVR}data/plots/region_xy.npy
${WGT} ${SRVR}data/plots/plots.mat

cd ../..
