function [ ids ] = getIdsFromFrame( frameData )
% Returns ids of rectangles from the specified frame
% frameData: struct from the "data.mat"
% ids: integer array with ids

n = frameData.nObjects;
ids = zeros(n,1);
for i = 1:n % fill in
    ids(i) = str2double(frameData.objects(i).id);
end

end

