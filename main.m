clear all;
load data.mat;

ids = greedyRT_XY_only( data );
error = checkTracking( data, ids )