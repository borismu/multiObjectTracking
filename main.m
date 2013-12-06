clear all;
load data.mat;
%load data3.mat; % load data with reduced FPS - use reduceDataFPS to
% generate these files

ids = greedyRT_XY_only( data );

checkTracking( data, ids )
checkTrackingBoris( data, ids )