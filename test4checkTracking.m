% Sanity check for checkTracking(). Should return 0

clear all;
load data.mat;

ids = {};
idsFake = {};

for frame=1:data.nFrames
    idsOrig = getIdsFromDataFrame(data.Frames(frame));    
    ids{frame} = idsOrig;
    idsFake{frame} = [1];
end;

error = checkTracking( data, ids );
errorF = checkTracking( data, idsFake );

fprintf('Error rate on the original: %f\n', error);
fprintf('Error rate on a faked result: %f\n', errorF);

