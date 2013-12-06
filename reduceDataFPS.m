% Loads original data and creates 4 the very similiar files, with the same
% structures, but frames are reduced by a factor from 2 to 5

load data.mat

dataOrig = data;

for thin=2:5
    objects = {};
    nObjects = {};
    for iFrame=0:thin:dataOrig.nFrames
        f = dataOrig.Frames(iFrame+1);
        objects{end+1} = f.objects;
        nObjects{end+1} = f.nObjects;
    end
    
    n = numel(objects);
    n_str = arrayfun(@num2str, 0:n-1, 'unif', 0);
    data = struct('nFrames', n, 'Frames', struct(...
            'number',   n_str', ...
            'objects',  objects', ...
            'nObjects', nObjects')');
    
    fname = ['data', num2str(thin), '.mat'];
    save(fname, 'data');
end