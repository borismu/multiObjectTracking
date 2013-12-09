%clear all;

%load data3.mat;
%load data3.mat; % load data with reduced FPS - use reduceDataFPS to
% generate these files

err = [];
for i=1:10
    w = [1;4+i/10;0;0];
    ids = nearestRT( data, w );
    err(:,end+1) = [checkTrackingBoris( data, ids );checkTracking( data, ids );w];
end
err
%checkTracking( data, ids )
%checkTrackingBoris( data, ids )