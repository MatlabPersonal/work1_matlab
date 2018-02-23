function [FFout,IPAout,FSout] = matchEvents(indFF,indIPA,indFS)
n = length(indIPA);
FFout = zeros(1,n);
IPAout = zeros(1,n);
FSout = zeros(1,n);
for i = 1:n
    FStemp = intersect(find(indIPA(i) - indFS>0),find(indIPA(i) - indFS < 20));
    if(~isempty(FStemp))
        FStemp = indFS(FStemp(end));
        FFtemp = intersect(find(indIPA(i) - indFF<0),find(indIPA(i) - indFF >-20));
        if(~isempty(FFtemp))
            FFout(i) = indFF(FFtemp(1));
            FSout(i) = FStemp;
            IPAout(i) = indIPA(i);
        end
    end
    
end
FFout(FFout==0) = [];
IPAout(IPAout==0) = [];
FSout(FSout==0) = [];
end