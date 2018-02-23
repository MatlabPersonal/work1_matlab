function [IPA, IPAVector] = estimateIPA(InitPeakAcc)
 
stepAverage = 3; L = length(InitPeakAcc);
if(stepAverage >= L)    
    IPAVector = mean(InitPeakAcc);    
else
    IPAVector=zeros(1,L-stepAverage);
    for i=1:L-stepAverage
        IPAVector(i) = mean(InitPeakAcc(i:i+stepAverage));
    end
end

fs=1; %One stride per second 
[B,A]=butter(2,0.3/(fs/2),'low');
if (length(IPAVector)>6)
    temp=filtfilt(B,A,IPAVector);
    IPAVector=reshape(temp,1,[]);
end

IPAVector=-IPAVector; % Should we make IPA negative? <EC>
%FIXME: temp fix to prevent negative IPAs
IPAVector(IPAVector<0) = median(IPAVector(IPAVector>0))+rand;

IPA = mean(IPAVector);
IPAVector(isnan(IPAVector)) = median(IPAVector) + rand;
end