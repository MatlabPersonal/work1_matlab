
% Main Function
% function [FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, EdSlope_Left, EdSlope_Right, ToeOff_Left, ToeOff_Right] =...
%                             findRunningEvents(Stc,data_Left,data_Right)

 %function [events, detection] = findRunningEvents_CWT(Stc,data_Left,data_Right,...
 function [FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, edSlope_Left, edSlope_Right, ToeOff_Left, ToeOff_Right,...
           dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right] = ...
                                            findRunningEvents_CWT(Stc,data_Left,data_Right,...
                                                                  FootStrike_Left_True, InitPeakAcc_Left_True, FlatFoot_Left_True, stSlope_Left_True, EdSlope_Left_True, ToeOff_Left_True,... 
                                                                  FootStrike_Right_True, InitPeakAcc_Right_True, FlatFoot_Right_True, stSlope_Right_True, EdSlope_Right_True, ToeOff_Right_True)
%                                                               
% Left
% Calculate Supporting Wavelets
[swingWav_Left, stanceWav_IPA_Left, coeffs_Left] = calculateCWT_V2(data_Left);
% Find peaks/troughs in Acceleration Signals
[derivAcc_Left, dataFilt_Left, troughsSpeed_Left] = findPeaksTroughsAcc_V2(data_Left,Stc);
% % Find Events
[FlatFoot_Left,InitPeakAcc_Left,FootStrike_Left,ToeOff_Left, stSlope_Left, edSlope_Left] = findEvents_V2(Stc,data_Left, swingWav_Left, stanceWav_IPA_Left, derivAcc_Left,...
                                                                                                         FootStrike_Left_True, InitPeakAcc_Left_True, FlatFoot_Left_True, stSlope_Left_True, EdSlope_Left_True, ToeOff_Left_True);

% Right
% Calculate Supporting Wavelets
[swingWav_Right, stanceWav_IPA_Right, coeffs_Right] = calculateCWT_V2(data_Right);
% Find peaks/troughs in Acceleration Signals
[derivAcc_Right, dataFilt_Right, troughsSpeed_Right] = findPeaksTroughsAcc_V2(data_Right,Stc);
% % Find Events
[FlatFoot_Right,InitPeakAcc_Right,FootStrike_Right,ToeOff_Right, stSlope_Right, edSlope_Right] = findEvents_V2(Stc,data_Right, swingWav_Right, stanceWav_IPA_Right, derivAcc_Right,...
                                                                                                               FootStrike_Right_True, InitPeakAcc_Right_True, FlatFoot_Right_True, stSlope_Right_True, EdSlope_Right_True, ToeOff_Right_True);


% detectionRate_Left = findRatess(data_Left, swingWav_Left, stanceWav_IPA_Left, derivAcc_Left,...
%                                 FlatFoot_Left,InitPeakAcc_Left,FootStrike_Left,ToeOff_Left,...
%                                 FootStrike_Left_True, InitPeakAcc_Left_True, FlatFoot_Left_True, stSlope_Left_True, EdSlope_Left_True, ToeOff_Left_True);

% detectionRate_Right = findRatess(data_Right, swingWav_Right, stanceWav_IPA_Right, derivAcc_Right,...
%                                  FlatFoot_Right, InitPeakAcc_Right, FootStrike_Right, ToeOff_Right,...
%                                  FootStrike_Right_True, InitPeakAcc_Right_True, FlatFoot_Right_True, stSlope_Right_True, EdSlope_Right_True, ToeOff_Right_True);

% detection = [detectionRate_Left detectionRate_Right];
 
 end

