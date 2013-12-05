function [perror] = comparewithoriginal(truedata, mydata,Nframes)

trueobjectsnormalobjects = [0 0];
numberofallobjrect = 0;
numberofsmissed = 0;

for iFrame=1:min(Nframes, truedata.nFrames)
    trueframe = truedata.Frames(iFrame);
    myframe = mydata.Frames(iFrame);
    nObjs = trueframe.nObjects;
    for iObj = 1:nObjs
        trueobj = trueframe.objects(iObj);
        trueid = trueobj.id;
        if (ischar(trueid))
            trueid = str2double(trueid);
        end
        obj = myframe.objects(iObj);
        id = obj.id;
        if (ischar(id))
            id = str2double(id);
        end
        if (sum(trueobjectsnormalobjects(:,1) == trueid)==0)&(sum(trueobjectsnormalobjects(:,2) == id)==0)
            trueobjectsnormalobjects = [trueobjectsnormalobjects; [trueid,id]];
        elseif(trueobjectsnormalobjects(trueobjectsnormalobjects(:,1) == trueid,2) ~= id)
            numberofsmissed = numberofsmissed + 1;
        elseif(trueobjectsnormalobjects(trueobjectsnormalobjects(:,2) == id,1) ~= trueid)
            numberofsmissed = numberofsmissed + 1;
        end
        numberofallobjrect = numberofallobjrect + 1;
    end;
end;

perror = numberofsmissed/numberofallobjrect;

end