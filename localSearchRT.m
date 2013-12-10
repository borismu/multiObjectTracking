function [ ids ] = localSearchRT( data, w )
% Solves tracking problem using frame-wise local search through all the
% permutations
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
    
    %-------- search for the right permutation
    [m,n] = size(dmat);
    %n = size(dmat,2);
    
    % first guess
    ix = zeros(n, 1);
    if n<m
        ix = 1:n;
    else
        ix(1:m) = 1:m;
    end
    
    cost = costFunction(dmat, ix);
    continueFlag = 1;
    while continueFlag
        continueFlag = 0;
        % test all the swaps
        for i=1:n
            for j=1:n
                nix = ix; % new ix
                nix([i,j]) = nix([j,i]); % swap
                newCost = costFunction(dmat, nix);
                if newCost < cost
                    ix = nix;
                    cost = newCost;
                    continueFlag = 1;
                end
            end
        end
        
        % test zeroing
        for i=1:n
        	nix = ix; % new ix
            nix(i) = 0;
            newCost = costFunction(dmat, nix);
            if newCost < cost
                ix = nix;
                cost = newCost;
                continueFlag = 1;
            end
        end
    end
    
    result = zeros(m,1);
    prev = ids{frame-1};
    
    % assign previous ids
    nz = find(ix>0);
    result(ix(nz)) = prev(nz);
    
    % create new ids
    for i=find(result==0)
        result(i) = idCounter;
        idCounter = idCounter+1;
    end
    
    ids{frame} = result;
end;

end

% dmat(i,j) = dist(next(i), prev(j))
% perm - permutation: result(perm)=prev
function cost = costFunction(dmat, perm)
    % how far away should rectangle jump to be considered as a different one
    divergeDistance = 1000;
    cost = 0;
    for i=1:numel(perm)
        if perm(i)==0
            cost = cost + divergeDistance;
        else
            cost = cost + dmat(perm(i),i);
        end
    end
end

