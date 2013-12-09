function dmat = getDistMatrix(data, frame, ids, w)
% Returns matrix of distances
%
% Inputs:
%   data - the struct that can be loaded from data.mat
%   frame - frame number
%   ids - previously computed labels
%   w - vector of weights
%
% Outputs:
%   dmat(i,j) = dist(next(i), prev(j));

xy = featureMatrix(data.Frames(frame), w);
xyP = featureMatrix(data.Frames(frame-1), w);

xyPP = xyP; %% prev-prev feature vectors
if frame>2
    [~,permut] = ismember(ids{frame-2}, ids{frame-1}); % permutation
    filter = find(permut>0); % remove non-zeros
    permut = permut(filter);

    xyPPN = featureMatrix(data.Frames(frame-2), w);
    xyPP(:,permut) = xyPPN(:,filter); % permute it so we'll have corresponding fv's
end

% Set to a predicted position.
% The explanation is that dv = xa-2*x0-x1.
% So we set 5-th and 6-th lines of xyP to this value
xyP([5 6],:) = xyP([5 6],:)*2 - xyPP([5 6],:);

dmat = [];
for i=1:size(xy,2)
    for j=1:size(xyP,2)
        a = xy(:,i);
        b = xyP(:,j);
        dmat(i,j) = norm(a-b);
    end
end

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
    r = [sscanf(box.xc, '%f'); sscanf(box.yc, '%f')];
    s = [sscanf(box.w, '%f'); sscanf(box.h, '%f')];
    %s = [str2double(box.w);  str2double(box.h) ];
    hog = obj.hog;
    h = reshape(hog, 10*5*31, 1);
    v = [r*w(1); s*w(2); r*w(3); h*w(4)];
end
