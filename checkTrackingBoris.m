function error = checkTrackingBoris(data, ids)

teMap = [0, 0]; % maps true objects to estimated ones
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
        
        if ~(ismember(tid, teMap(:,1)) || ismember(eid, teMap(:,2)))
            teMap(end+1,:) = [tid, eid];
        elseif(teMap(teMap(:,1) == tid,2) ~= eid)
            nMissed = nMissed + 1;
        elseif(teMap(teMap(:,2) == eid,1) ~= tid)
            nMissed = nMissed + 1;
        end
        
        nAllObjs = nAllObjs + 1;
    end;
end;

error = nMissed/nAllObjs;

end