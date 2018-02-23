
% Main Function
% function [FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, EdSlope_Left, EdSlope_Right, ToeOff_Left, ToeOff_Right] =...
%                             findRunningEvents(Stc,data_Left,data_Right)

 function [FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, EdSlope_Left, EdSlope_Right, ToeOff_Left, ToeOff_Right,...
           dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right] = findRunningEvents(Stc,data_Left,data_Right,i,k,m,team,counter)

% Left
% Calculate Supporting Wavelets
[swingWav_Left,stanceWav_Left,stanceWav_IPA_Left,coeffs_Left] = calculateCWT(data_Left,Stc);
% Find peaks/troughs of Supporting Wavelets
[stSlope_Left,locsST_Left,locsNegIPA_ST_Left, EdSlope_Left,derivswingWav_Left] = findPeaksWav(swingWav_Left,stanceWav_Left,stanceWav_IPA_Left,Stc,data_Left);
% Find peaks/troughs in Acceleration Signals
[indZero_Left, derivAcc_Left, dataFilt_Left, troughsSpeed_Left] = findPeaksTroughsAcc(data_Left,Stc);
% Find Events
[FlatFoot_Left,InitPeakAcc_Left,FootStrike_Left,ToeOff_Left] = findEvents(locsST_Left,locsNegIPA_ST_Left,stSlope_Left,EdSlope_Left,indZero_Left, data_Left,dataFilt_Left,coeffs_Left);
%FlatFoot_Left = indZero_Left(indFF_Left);

% Right
% Calculate Supporting Wavelets
[swingWav_Right,stanceWav_Right,stanceWav_IPA_Right,coeffs_Right] = calculateCWT(data_Right,Stc);
% Find peaks/troughs of Supporting Wavlets
[stSlope_Right,locsST_Right,locsNegIPA_ST_Right, EdSlope_Right,derivswingWav_Right] = findPeaksWav(swingWav_Right,stanceWav_Right,stanceWav_IPA_Right,Stc,data_Right);
% Find peaks/troughs in Acceleration Signals
[indZero_Right, derivAcc_Right, dataFilt_Right, troughsSpeed_Right] = findPeaksTroughsAcc(data_Right, Stc);
% Find Events
[FlatFoot_Right,InitPeakAcc_Right,FootStrike_Right,ToeOff_Right] = findEvents(locsST_Right,locsNegIPA_ST_Right,stSlope_Right,EdSlope_Right,indZero_Right, data_Right, dataFilt_Right,coeffs_Right);
%FlatFoot_Right = indZero_Right(indFF_Right);

%% Plot Gait Events & Wavelet Map                  
plotWavelets(Stc, data_Left,coeffs_Left,swingWav_Left,stanceWav_Left,stanceWav_IPA_Left,swingWav_Left,derivswingWav_Left,EdSlope_Left,stSlope_Left,locsST_Left,locsNegIPA_ST_Left,indZero_Left, derivAcc_Left, dataFilt_Left,FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, EdSlope_Left, ToeOff_Left,...
                  data_Right,coeffs_Right,swingWav_Right,stanceWav_Right,stanceWav_IPA_Right,swingWav_Right,derivswingWav_Right,EdSlope_Right,stSlope_Right,locsST_Right,locsNegIPA_ST_Right,indZero_Right, derivAcc_Right, dataFilt_Right,FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, EdSlope_Right,ToeOff_Right,...
                  k,i,m,team,counter);
                                             
end