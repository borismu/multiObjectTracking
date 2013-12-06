function error = checkTrackingBoris(data, ids)

teMap = containers.Map({0}, {0}); % maps true objects to estimated ones
nAllObjs = 0;
nMissed = 0;

for iFrame=1:data.nFrames
    frame = data.Frames(iFrame);
    id = ids{iFrame};
    
    nObjs = frame.nObjects;
    trueId = getIdsFromDataFrame(frame);
    
    for i = 1:nObjs
        tid = trueId(i); % true id
        eid = id(i); % estimated id
        
        if teMap.isKey(tid)
            if teMap(tid) ~= eid
                nMissed = nMissed + 1;
            end
        else
            teMap(tid) = eid;
        end
        
        nAllObjs = nAllObjs + 1;
    end;
end;

error = nMissed/nAllObjs;

end