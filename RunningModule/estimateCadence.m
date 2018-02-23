function [Cadence,CadenceVector] = estimateCadence(Stc, InitPeakAcc_Left,InitPeakAcc_Right)

timeDelta_Left = zeros(1,length(InitPeakAcc_Left)-1);
%timeDelta_Left(1:length(InitPeakAcc_Left)-1)=0;
for i=1:length(InitPeakAcc_Left)-1
    timeDelta_Left(i)=Stc(InitPeakAcc_Left(i+1)) - Stc(InitPeakAcc_Left(i));
end

timeDelta_Right = zeros(1,length(InitPeakAcc_Right)-1);
%timeDelta_Right(1:length(InitPeakAcc_Right)-1)=0;
for i=1:length(InitPeakAcc_Right)-1
    timeDelta_Right(i)=Stc(InitPeakAcc_Right(i+1)) - Stc(InitPeakAcc_Right(i));  
end

% Remove wrong cadence
thresholdTimeDelta = 4000;
timeDelta_Left(timeDelta_Left > thresholdTimeDelta) = [];
timeDelta_Right(timeDelta_Right > thresholdTimeDelta) = [];

% Interpolate both
%timeDelta_Left=medfilt1(timeDelta_Left);
%timeDelta_Right=medfilt1(timeDelta_Right);

% Remove zeros in case there are zeros or NaN
timeDelta_Left(timeDelta_Left==0)=[];timeDelta_Left(isnan(timeDelta_Left))=[];
timeDelta_Right(timeDelta_Right==0)=[];timeDelta_Right(isnan(timeDelta_Right))=[];

% Average with 3 strides
stepAverage = 3; timeDeltaVector = zeros(1,length(timeDelta_Left)-stepAverage);
for i=1:length(timeDelta_Left)-stepAverage
    timeDeltaVector(i) = mean(timeDelta_Left(i:i+stepAverage));
end

%timeDelta_Average = mean([mean(timeDelta_Left) mean(timeDelta_Right)]);
CadenceVector = 2*60./(timeDeltaVector/1000);
% FIXME: cadence vector will be clipped at 300
CadenceVector(CadenceVector>300) = 250+rand*50;

Cadence = median(CadenceVector);

if(length(CadenceVector)>6)
    fs=1;
    [B,A]=butter(2,0.3/(fs/2),'low');    
     temp = filtfilt(B,A,CadenceVector);    
     CadenceVector=reshape(temp,1,[]);
end
CadenceVector(isnan(CadenceVector)) = median(CadenceVector)+rand;
end