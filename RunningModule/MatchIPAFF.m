function [locsOut1, locsOut2] = MatchIPAFF(locsin1,locsin2,threshold)
len1 = length(locsin1);
len2 = length(locsin2);
finishFlag = 0;
Cursor1 = 1;
Cursor2 = 1;
while(finishFlag == 0 && ~isempty(locsin1) && ~isempty(locsin2))

    if(abs(locsin2(Cursor2)-locsin1(Cursor1))<threshold)
        Cursor1 = Cursor1 + 1; 
        Cursor2 = Cursor2 + 1;
    elseif(locsin1(Cursor1)<locsin2(Cursor2))
        locsin1(Cursor1) = NaN;
        Cursor1 = Cursor1 + 1;
    else
        locsin2(Cursor2) = NaN;
        Cursor2 = Cursor2 + 1;
    end
    if(Cursor1>len1 || Cursor2>len2)
        finishFlag = 1;
    end
end
locsin1(isnan(locsin1)) = [];
locsin2(isnan(locsin2)) = [];
len = min([length(locsin1) length(locsin2)]);
locsOut1 = locsin1(1:len);
locsOut2 = locsin2(1:len);
end