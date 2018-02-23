%function [Speed, SpeedVector, SpeedVectorLeft, SpeedVectorRight, integrationCue] = estimateSpeedModel2(Stc, dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right)
function [Speed, SpeedVector, integrationCue, idxSplitLeft, idxSplitRight] = estimateSpeedModel2(Stc, dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right)

L_Left = length(troughsSpeed_Left);L_Right = length(troughsSpeed_Right);
% Interpolate
if(L_Left>L_Right)
    dataFilt_Right_Intp1=interp1(Stc(troughsSpeed_Right),dataFilt_Right(troughsSpeed_Right),Stc(troughsSpeed_Left));
    avDataFilt= mean([dataFilt_Left(troughsSpeed_Left);dataFilt_Right_Intp1]);
    integrationCue = [troughsSpeed_Left(1) troughsSpeed_Left(end)];
    
%     dataTroughLeft = dataFilt_Left(troughsSpeed_Left);
%     dataTroughRight = dataFilt_Right_Intp1;
else
    dataFilt_Left_Intp1=interp1(Stc(troughsSpeed_Left),dataFilt_Left(troughsSpeed_Left),Stc(troughsSpeed_Right));
    avDataFilt= mean([dataFilt_Left_Intp1;dataFilt_Right(troughsSpeed_Right)]);
    integrationCue = [troughsSpeed_Right(1) troughsSpeed_Right(end)];
    
%     dataTroughLeft = dataFilt_Left_Intp1;
%     dataTroughRight = dataFilt_Right(troughsSpeed_Right);
end

% Use both legs for speed estimation
stepAverage = 3; SpeedVector = zeros(1,length(avDataFilt)-stepAverage);
for i=1:length(avDataFilt)-stepAverage
    SpeedVector(i) = mean(avDataFilt(i:i+stepAverage));
end

SpeedVector(isnan(SpeedVector))=[];
SpeedVector=(7.4*log2(abs(SpeedVector)-1)+6.40);
%SpeedVector = 75.7*SpeedVector+6.15;

if(length(SpeedVector)>6)
    fs=1; %One stride per second
    [B,A]=butter(2,0.3/(fs/2),'low');
    temp = filtfilt(B,A,SpeedVector);
    SpeedVector = reshape(temp,1,[]);
end

% threshold = 1600;
% testL = find(diff(Stc(troughsSpeed_Left)) > threshold);
% testR = find(diff(Stc(troughsSpeed_Right)) > threshold);

% figure; a(1)=subplot(2,1,1);
% plot(dataFilt_Left,'b')
% hold on
% plot(troughsSpeed_Left(testL),dataFilt_Left(troughsSpeed_Left(testL)),'ro','linewidth',2)
% a(2)=subplot(2,1,2);
% plot(dataFilt_Right,'b')
% hold on
% plot(troughsSpeed_Right(testR),dataFilt_Right(troughsSpeed_Right(testR)),'ro','linewidth',2)
% linkaxes(a,'x');

%% Last fix
% Speed = median(SpeedVector);  %Change to median <FIXME>
SpeedVector=SpeedVector*0.82+3.6;

for k=1:length(SpeedVector)
    if(SpeedVector(k)<=12)
        SpeedVector(k)=SpeedVector(k)*0.88+0.6;
    end
end

Speed = mean(SpeedVector);  %Change to median <FIXME>

%%
% figure;
% subplot(2,1,1);
% plot(troughsSpeed_Left(1:end-1),diff(Stc(troughsSpeed_Left))); hold on;
% plot(troughsSpeed_Right(1:end-1),diff(Stc(troughsSpeed_Right)),'r');

thresholdTime = 2000;
idxSplitLeft = find(diff(Stc(troughsSpeed_Left))>thresholdTime);
idxSplitRight = find(diff(Stc(troughsSpeed_Right))>thresholdTime);

% subplot(2,1,2);
% plot(Stc,dataFilt_Left)
% hold on
% plot(Stc(troughsSpeed_Left(idxSplitLeft)),dataFilt_Left(troughsSpeed_Left(idxSplitLeft)),'co','linewidth',2)
% plot(Stc,dataFilt_Right,'r')
% plot(Stc(troughsSpeed_Right(idxSplitRight)),dataFilt_Right(troughsSpeed_Right(idxSplitRight)),'go','linewidth',2)
% plot(Stc(troughsSpeed_Left),dataFilt_Left(troughsSpeed_Left),'kx');
% plot(Stc(troughsSpeed_Right),dataFilt_Left(troughsSpeed_Right),'bx');

%% Test with Left and Right independently
% Use both legs for speed estimation
% stepAverage = 3; 
% dataTroughLeftVector = zeros(1,length(dataTroughLeft)-stepAverage);
% dataTroughRightVector = zeros(1,length(dataTroughLeft)-stepAverage);
% for i=1:length(dataTroughLeft)-stepAverage
%     dataTroughLeftVector(i) = mean(dataTroughLeft(i:i+stepAverage));
%     dataTroughRightVector(i) = mean(dataTroughRight(i:i+stepAverage));
% end
% 
% SpeedVectorLeft=7.40*log2(abs(dataTroughLeftVector)-1)+6.40;
% SpeedVectorRight=7.40*log2(abs(dataTroughRightVector)-1)+6.40;
% 
% SpeedVectorLeft(isnan(SpeedVectorLeft))=[];
% SpeedVectorRight(isnan(SpeedVectorRight))=[];
end