function error = checkTracking( data, estimatedIds )
% error = checkTracking( data, estimatedIds )
% Compares ids in data and in estimatedIds
% Inputs:
%   data - a struct, that can be loaded from "data.mat"
%   estimatedIds - cell array, with size data.nFrames, each element is a
%       vector of integers, representing an id of the corresponding
%       rectangle from the data.
% Outputs:
%   error - double from 0 to 1, showing percentage of wringly tracked rects

nRectangles = 0;
nCorrectlyTracked = 0;

for frame=2:data.nFrames
    % current frame
    idsEst = estimatedIds{frame}; % estimated ids
    idsOrig = getIdsFromDataFrame(data.Frames(frame)); % original ids
    
    % previous frame
    idsEstPrev = estimatedIds{frame-1}; % estimated
    idsOrigPrev = getIdsFromDataFrame(data.Frames(frame-1)); % original
    
    % find and compare permutatings
    [~, permutingOrig] = ismember(idsOrig, idsOrigPrev);
    [~, permutingEst]  = ismember(idsEst, idsEstPrev);
    
    % update statistics
    nRectangles = nRectangles + numel(idsOrig);
    nCorrectlyTracked = nCorrectlyTracked + ...
        sum(permutingOrig==permutingEst);
end;

error = 1 - nCorrectlyTracked/nRectangles;

end
