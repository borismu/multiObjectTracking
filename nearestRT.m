function [ ids ] = nearestRT( data, w )
% Solves tracking problem in the easiest way - just selecting the nearest
% rect from the next frame. Distance is measured using coordinates, scale,
% velocity and hog with some weights w.
%
% Inputs:
%   data - struct that can be read from data.mat or generated with
%       reduceDataFPS
%   w = [xy; scale; velocity; hog] is a vector (4x1) of boosting weights
%
% Outputs:
%   ids - cell array, with size data.nFrames, each element is a
%       vector of integers, representing an id of the corresponding
%       rectangle from the data.

% how far away should rectangle jump to be considered as a different one
divergeDistance = 50;

idCounter = 1; % id for each new rectangle
ids = {};

% the first frame
frameData = data.Frames(1);
nObjs = frameData.nObjects;
ids{1} = (1:nObjs)';
idCounter = 1+nObjs;

% loop through all the frames
for frame=2:data.nFrames
    % current frame
    frameData = data.Frames(frame);
    xy = featureMatrix(frameData, w);
    
    % previous frame
    frameDataPrev = data.Frames(frame-1);
    xyP = featureMatrix(frameDataPrev, w);
    
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
function fmat = featureMatrix(frameData, w)
    nObjs = frameData.nObjects;
    fmat = [];
    for i = 1:nObjs
        obj = frameData.objects(i);
        fmat(:, i) = getFVector(obj, w);
    end;
end

% returns one feature vector for one object
% w = [a;b;c;d] is a vector of weights
% a - stands for xy, b - scale, c - velocity, d - hog
function v = getFVector(obj, w)
    box = obj.box;
    r = [str2double(box.xc); str2double(box.yc)];
    s = [str2double(box.w);  str2double(box.h) ];
    hog = obj.hog;
    h = reshape(hog, 10*5*31, 1);
    v = [r*w(1); s*w(2); h*w(4)];
end


