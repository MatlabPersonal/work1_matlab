function  [GRF, GRFVector] = estimateGRF_old(FlatFoot, BodyMass)

a=4.66*BodyMass - 76.6;
b=1;
c=24.98*BodyMass - 566.83;
    
stepAverage = 3; L = length(FlatFoot);
if(stepAverage >= L)    
    FlatFootVector = mean(FlatFoot);    
else
    FlatFootVector=zeros(1,L-stepAverage);
    for i=1:L-stepAverage
        FlatFootVector(i) = mean(FlatFoot(i:i+stepAverage));
    end
end

GRFVector=zeros(1,L);GRF=0;

fs=1; %One stride per second 
[B,A]=butter(2,0.3/(fs/2),'low');
if (length(FlatFootVector)>6)
    temp = filtfilt(B,A,FlatFootVector);
    FlatFootVector = reshape(temp,1,[]);
end    
FlatFootVector((FlatFootVector+1)<0)=[]; % Get rid of unwanted -1 values for log

if(~isempty(FlatFootVector))
    FlatFoot = median(FlatFootVector); % Change to median <FIXME>    
    GRFVector = a*log2(FlatFootVector+b)+c;
    GRF = a*log2(FlatFoot+b)+c;
end
    
end