function [ ids ] = greedyRT_XY_only( data )
%GREEDYRT_XY_ONLY Summary of this function goes here
%   Detailed explanation goes here

% how far away should rectangle jump to be considered as a different one
divergeDistance = 25;

idCounter = 1; % id for each new rectangle
ids = {};

% the first frame
frameData = data.Frames(1);
nObjs = frameData.nObjects;
ids{1} = (1:nObjs)';
idCounter = 1+nObjs;

for frame=2:data.nFrames
    % current frame
    frameData = data.Frames(frame);
    xy = featureMatrix(frameData);
    
    % previous frame
    frameDataPrev = data.Frames(frame-1);
    xyP = featureMatrix(frameDataPrev);
    
    % distances matrix
    dist = [];
    for i=1:size(xy,2)
        for j=1:size(xyP,2)
            a = xy(:,i);
            b = xyP(:,j);
            dist(i,j) = norm(a-b);
        end
    end
    
    % get min distances
    [d, ix] = min(dist);
    
    n = size(xy,2);
    result = zeros(n,1);
    prev = ids{frame-1};
    
    % assign previous ids
    result(ix) = prev;
    
    % check if it is too far away
    for i=1:numel(d)
        if d(i) > divergeDistance
            result(ix(i)) = idCounter;
            idCounter = idCounter+1;
        end
    end
    
    % create new ids
    for i=1:n
        if result(i) == 0
            result(i) = idCounter;
            idCounter = idCounter+1;
        end
    end
    
    ids{frame} = result;
end;

end

% returns matrix of features (nFeatures, nRectangles)
function fmat = featureMatrix(frameData)
    nObjs = frameData.nObjects;
    fmat = zeros(2,nObjs);
    for i = 1:nObjs
        obj = frameData.objects(i);
        box = obj.box;
        fmat(:, i) = [str2double(box.xc); str2double(box.yc)];
    end;
end