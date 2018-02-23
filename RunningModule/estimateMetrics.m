function  [GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
    GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
    ContactTime_Left, ContactTimeVector_Left,...
    ContactTime_Right, ContactTimeVector_Right,...
    Speed, SpeedVector,Distance, DistanceVector,...
    Cadence, CadenceVector, RunTime, StrideNumber,...
    ASI,ASI_Vector,time_Left,time_Right] = ...
    estimateMetrics(Stc, BodyMass, data_Left, data_Right,energyTH)

GRF_Left=0; GRF_Vector_Left=zeros(1,1); IPA_Left=0; IPA_Vector_Left=zeros(1,1);
GRF_Right=0; GRF_Vector_Right=zeros(1,1); IPA_Right=0; IPA_Vector_Right=zeros(1,1);
ContactTime_Left=0; ContactTimeVector_Left=zeros(1,1);
ContactTime_Right=0; ContactTimeVector_Right=zeros(1,1);
Speed=0; SpeedVector=zeros(1,1);Distance=0; DistanceVector=zeros(1,1);
Cadence=0; CadenceVector=zeros(1,1); RunTime=0; StrideNumber=0;
ASI=0;ASI_Vector=zeros(1,1);
time_Left = zeros(1,1);
time_Right = zeros(1,1);

% find events, wrapped in estimate Metrics
[FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, EdSlope_Left, EdSlope_Right, ToeOff_Left, ToeOff_Right,...
    dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right] = ...
    findRunningEvents_V2(Stc,data_Left,data_Right,energyTH);
% time out vector
time_Left = Stc(InitPeakAcc_Left);
time_Right = Stc(InitPeakAcc_Right);

% Check empty events
NumberEvents = 3;
if (length(FootStrike_Left)>=NumberEvents && length(InitPeakAcc_Left)>=NumberEvents && length(FlatFoot_Left)>=NumberEvents && length(stSlope_Left)>=NumberEvents && length(EdSlope_Left)>=NumberEvents && length(ToeOff_Left)>=NumberEvents && length(troughsSpeed_Left)>=NumberEvents &&...
        length(FootStrike_Right)>=NumberEvents && length(InitPeakAcc_Right)>=NumberEvents && length(FlatFoot_Right)>=NumberEvents && length(stSlope_Right)>=NumberEvents && length(EdSlope_Right)>=NumberEvents && length(ToeOff_Right)>=NumberEvents && length(troughsSpeed_Right)>=NumberEvents)
    
    
    % Average time deltas
    data_Left(isnan(Stc)) = [];
    data_Right(isnan(Stc)) = [];
    Stc(isnan(Stc)) = [];
    
    timeDelta=100;
    Stc = averageTime(Stc,timeDelta);
    data_Left=data_Left(1:end-timeDelta);
    data_Right=data_Right(1:end-timeDelta);
    dataFilt_Left=dataFilt_Left(1:end-timeDelta);
    dataFilt_Right=dataFilt_Right(1:end-timeDelta);
    
    %% Average of both legs
    %       [Speed, SpeedVector, integrationCue] = estimateSpeed(Stc, data_Left, data_Right, stSlope_Left, EdSlope_Left, stSlope_Right, EdSlope_Right);
    %         [SpeedModel2, SpeedVectorModel2, integrationCueModel2,idxSplitLeft, idxSplitRight] = estimateSpeedModel2(Stc, dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right);
    [SpeedModel3, SpeedVectorModel3,DistanceModel3, DistanceVectorModel3] = estimateSpeedModel3(Stc, dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right);
    %       [Distance, DistanceVector] = estimateDistance(Stc,integrationCue, SpeedVector);
    %         [DistanceModel2, DistanceVectorModel2] = estimateDistance(Stc,integrationCueModel2, SpeedVectorModel2,idxSplitLeft, idxSplitRight, troughsSpeed_Left, troughsSpeed_Right);
    %         [DistanceModel3, DistanceVectorModel3] = estimateDistance2(Stc,SpeedVectorModel3);
    [Cadence, CadenceVector] = estimateCadence(Stc, InitPeakAcc_Left,InitPeakAcc_Right); % St of Slope seems more consistent
    StrideNumber = estimateStrides(stSlope_Left,stSlope_Right); % St of Slope seems more consistent
    RunTime = estimateRunTime(Stc, FlatFoot_Left(1), ToeOff_Left(end));
    %         Speed=SpeedModel2; SpeedVector=SpeedVectorModel2;Distance=DistanceModel2; DistanceVector=DistanceVectorModel2;
    Speed=SpeedModel3; SpeedVector=SpeedVectorModel3;Distance=DistanceModel3; DistanceVector=DistanceVectorModel3;
    % new - stride Length (not integrated in vimove2)
%     [strideLength, strideLengthVector] = estimateStrideLength(DistanceVector);
    %% Data Left
    
    % match IPA and FF - Derek
    [InitPeakAcc_Left,FlatFoot_Left] = MatchIPAFF(InitPeakAcc_Left,FlatFoot_Left,10);
    dataInitPeakAcc = data_Left(InitPeakAcc_Left);
    dataFlatFoot = data_Left(FlatFoot_Left);
    
    % modified here estimate GRF - Derek
    [IPA_Left, IPA_Vector_Left] = estimateIPA(dataInitPeakAcc);
    
    [GRF_Left, GRF_Vector_Left] = estimateGRF_NN(dataInitPeakAcc, dataFlatFoot, Speed, BodyMass);
    
    %         [GRF_Left, GRF_Vector_Left] = estimateGRF_old(dataFlatFoot, BodyMass);
    [ContactTime_Left, ContactTimeVector_Left] = estimateContactTime(Stc, FootStrike_Left, ToeOff_Left, SpeedVector);
    
    %% Data Right
    
    % match IPA and FF - Derek
    [InitPeakAcc_Right,FlatFoot_Right] = MatchIPAFF(InitPeakAcc_Right,FlatFoot_Right,10);
    dataInitPeakAcc = data_Right(InitPeakAcc_Right);
    dataFlatFoot = data_Right(FlatFoot_Right);
    
    % modified here estimate GRF - Derek
    [IPA_Right, IPA_Vector_Right] = estimateIPA(dataInitPeakAcc);
    [GRF_Right, GRF_Vector_Right] = estimateGRF_NN(dataInitPeakAcc, dataFlatFoot, Speed, BodyMass);
    %         [GRF_Right, GRF_Vector_Right] = estimateGRF_old(dataFlatFoot, BodyMass);
    [ContactTime_Right, ContactTimeVector_Right] = estimateContactTime(Stc, FootStrike_Right, ToeOff_Right, SpeedVector);
    
    %% Find ASI
    [~,ASI_Vector] = findASI(GRF_Vector_Left,GRF_Vector_Right, FlatFoot_Left, FlatFoot_Right, Stc);
    ASI=100*(GRF_Right-GRF_Left)/(GRF_Left+GRF_Right+eps)*2;
    
    %% put all vector to same length
    maxlen = max([GRF_Vector_Left, IPA_Vector_Left, ...
        GRF_Vector_Right, IPA_Vector_Right, ...
        ContactTimeVector_Left,...
        ContactTimeVector_Right,...
        SpeedVector,DistanceVector,...
        CadenceVector,ASI_Vector]);
    if length(GRF_Vector_Left)>10 %if too short leave as it is
        GRF_Vector_Left = interp1(1:length(GRF_Vector_Left),GRF_Vector_Left,linspace(1,length(GRF_Vector_Left),maxlen));
    end
    if length(IPA_Vector_Left)>10 %if too short leave as it is
        IPA_Vector_Left = interp1(1:length(IPA_Vector_Left),IPA_Vector_Left,linspace(1,length(IPA_Vector_Left),maxlen));
    end
    if length(GRF_Vector_Right)>10 %if too short leave as it is
        GRF_Vector_Right = interp1(1:length(GRF_Vector_Right),GRF_Vector_Right,linspace(1,length(GRF_Vector_Right),maxlen));
    end
    if length(IPA_Vector_Right)>10 %if too short leave as it is
        IPA_Vector_Right = interp1(1:length(IPA_Vector_Right),IPA_Vector_Right,linspace(1,length(IPA_Vector_Right),maxlen));
    end
    if length(ContactTimeVector_Left)>10 %if too short leave as it is
        ContactTimeVector_Left = interp1(1:length(ContactTimeVector_Left),ContactTimeVector_Left,linspace(1,length(ContactTimeVector_Left),maxlen));
    end
    if length(ContactTimeVector_Right)>10 %if too short leave as it is
        ContactTimeVector_Right = interp1(1:length(ContactTimeVector_Right),ContactTimeVector_Right,linspace(1,length(ContactTimeVector_Right),maxlen));
    end
    if length(SpeedVector)>10 %if too short leave as it is
        SpeedVector = interp1(1:length(SpeedVector),SpeedVector,linspace(1,length(SpeedVector),maxlen));
    end
    if length(DistanceVector)>10 %if too short leave as it is
        DistanceVector = interp1(1:length(DistanceVector),DistanceVector,linspace(1,length(DistanceVector),maxlen));
    end
    if length(CadenceVector)>10 %if too short leave as it is
        CadenceVector = interp1(1:length(CadenceVector),CadenceVector,linspace(1,length(CadenceVector),maxlen));
    end
    if length(ASI_Vector)>10 %if too short leave as it is
        ASI_Vector = interp1(1:length(ASI_Vector),ASI_Vector,linspace(1,length(ASI_Vector),maxlen));
    end
    StrideNumber = round(maxlen); % FIXME: should put to actual value instead of detected value?
    if length(time_Left)>10
        time_Left = interp1(1:length(time_Left),time_Left,linspace(1,length(time_Left),maxlen));
    end
    if length(time_Right)>10
        time_Right = interp1(1:length(time_Right),time_Right,linspace(1,length(time_Right),maxlen));
    end
    %% Plot metrics
    plotMetrics(Stc,...
        GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ContactTime_Left, ContactTimeVector_Left,...
        GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ContactTime_Right, ContactTimeVector_Right,...
        ASI,ASI_Vector,Cadence, CadenceVector, Speed, SpeedVector, Distance, DistanceVector, ...
        troughsSpeed_Left, troughsSpeed_Right, SpeedModel3, SpeedVectorModel3, DistanceModel3, DistanceVectorModel3,...
        RunTime, StrideNumber,...
        FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, EdSlope_Left, ToeOff_Left,...
        FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, EdSlope_Right, ToeOff_Right),...
end
end