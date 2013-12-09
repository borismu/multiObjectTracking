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
divergeDistance = 200;

idCounter = 1; % id for each new rectangle
ids = {};

% the first frame
frameData = data.Frames(1);
nObjs = frameData.nObjects;
ids{1} = (1:nObjs)';
idCounter = 1+nObjs;

% loop through all the frames
for frame=2:data.nFrames
    dmat = getDistMatrix(data, frame, ids, w);
    
    % get min distances
    [d, ix] = min(dmat);
    % actually, this line was an essence of the whole method
    
    frameData = data.Frames(frame);
    n = frameData.nObjects;
    result = zeros(n,1);
    prev = ids{frame-1};
    
    % solve conflicts
    u = unique(ix);
    if numel(u) < numel(d)
        h = histc(ix,u); % count occurrences
        for i=find(h>1) % Gotcha! here is ours conflict
            same = find(ix==u(i)); % rects with the same index
            [~,m] = min(d(same)); % the closest of them
            same = removerows(same','ind',m); % rows to remove
            
            ix = removerows(ix','ind',same); % remove them
            d = removerows(d','ind',same); % remove
            prev = removerows(prev,'ind',same); % remove
        end
    end
    
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


