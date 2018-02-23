function [strideLength] = strideLenEstimateWrapper(time1,acc_left1,acc_right1)
BodyMass = 80;
[FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, EdSlope_Left, EdSlope_Right, ToeOff_Left, ToeOff_Right,...
    dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right] = findRunningEvents_V2(time1,-acc_left1,-acc_right1,1); % Left and Right);

[GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
    GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
    ContactTime_Left, ContactTimeVector_Left,...
    ContactTime_Right, ContactTimeVector_Right,...
    Speed, SpeedVector,Distance, DistanceVector,...
    Cadence, CadenceVector, RunTime, StrideNumber,...
    ASI,ASI_Vector,strideLength, strideLengthVector] = ...
    estimateMetrics(time1, BodyMass, acc_left1, FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, EdSlope_Left, ToeOff_Left,...
    acc_right1, FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, EdSlope_Right, ToeOff_Right,...
    dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right,acc_right1,acc_right1);
end