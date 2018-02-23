function [FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, edSlope_Left, edSlope_Right, ToeOff_Left, ToeOff_Right,...
           dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right] = ...
                                            findRunningEvents_V2(Stc,data_Left,data_Right,energyThreshold)%,k,i,m,team,counter)

L=1;
FootStrike_Left=zeros(1,L); FootStrike_Right=zeros(1,L); InitPeakAcc_Left=zeros(1,L); InitPeakAcc_Right=zeros(1,L);
FlatFoot_Left=zeros(1,L); FlatFoot_Right=zeros(1,L);
stSlope_Left=zeros(1,L); stSlope_Right=zeros(1,L);
edSlope_Left=zeros(1,L); edSlope_Right=zeros(1,L); ToeOff_Left=zeros(1,L); ToeOff_Right=zeros(1,L);
dataFilt_Left=zeros(1,L); troughsSpeed_Left=zeros(1,L); dataFilt_Right=zeros(1,L); troughsSpeed_Right=zeros(1,L);

% Check data length
sessionMinLength = 300;
if (length(data_Left)>sessionMinLength && length(data_Right)>sessionMinLength && length(Stc)>sessionMinLength)
    
    % Average time deltas
    data_Left(isnan(Stc)) = [];
    data_Right(isnan(Stc)) = [];
    Stc(isnan(Stc)) = [];

    timeDelta=100;
    Stc = averageTime(Stc,timeDelta);
    
    %derek: filter data (for walking and new algorithm)
    [B,A]=butter(4,49/(100/2),'low');  %use 10
    temp1 = data_Left(1:end-timeDelta);
    temp2 = data_Right(1:end-timeDelta);
    temp3=filtfilt(B,A,temp1);
    temp4=filtfilt(B,A,temp2);
    data_Left(1:length(temp3)) = temp3;
    data_Right(1:length(temp4)) = temp4;
    data_Left(length(temp3)+1:end) = [];
    data_Right(length(temp4)+1:end) = [];
    % Left
    % Calculate Supporting Wavelets
    [swingWav_Left, stanceWav_IPA_Left, coeffs_Left] = calculateCWT_V2(data_Left);
    % Find peaks/troughs in Acceleration Signals
    [derivAcc_Left, dataFilt_Left, troughsSpeed_Left] = findPeaksTroughsAcc_V2(data_Left,Stc);
    % Energy calculation
    [energyLeft,energyFiltLeft]=findEnergy(Stc,swingWav_Left,data_Left);
    % Find Events
    [FlatFoot_Left,InitPeakAcc_Left,FootStrike_Left,ToeOff_Left, stSlope_Left, edSlope_Left, troughsSpeed_Left] = findEvents_V2(Stc,data_Left, swingWav_Left, derivAcc_Left,energyFiltLeft,troughsSpeed_Left,energyThreshold);%,...
    %                                                                                                          FootStrike_Left_True, InitPeakAcc_Left_True, FlatFoot_Left_True, stSlope_Left_True, EdSlope_Left_True, ToeOff_Left_True);    

    % Right
    % Calculate Supporting Wavelets
    [swingWav_Right, stanceWav_IPA_Right, coeffs_Right] = calculateCWT_V2(data_Right);
    % Find peaks/troughs in Acceleration Signals
    [derivAcc_Right, dataFilt_Right, troughsSpeed_Right] = findPeaksTroughsAcc_V2(data_Right,Stc);
    % Energy calculation
    [energyRight,energyFiltRight]=findEnergy(Stc,swingWav_Right,data_Right);
    % Find Events
    [FlatFoot_Right,InitPeakAcc_Right,FootStrike_Right,ToeOff_Right, stSlope_Right, edSlope_Right, troughsSpeed_Right] = findEvents_V2(Stc,data_Right, swingWav_Right, derivAcc_Right,energyFiltRight,troughsSpeed_Right,energyThreshold);%,...
    %                                                                                                                FootStrike_Right_True, InitPeakAcc_Right_True, FlatFoot_Right_True, stSlope_Right_True, EdSlope_Right_True, ToeOff_Right_True);
    
    

    %% Plot Gait Events & Wavelet Map             
%     plotWavelets(Stc, data_Left,swingWav_Left,stanceWav_IPA_Left, dataFilt_Left,FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, edSlope_Left, ToeOff_Left,troughsSpeed_Left,...
%                       data_Right,swingWav_Right,stanceWav_IPA_Right, dataFilt_Right,FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, edSlope_Right,ToeOff_Right,troughsSpeed_Right,...
%                       energyLeft,energyRight,energyFiltLeft,energyFiltRight);%,...
% %                       k,i,m,team,counter);
                  

end
end