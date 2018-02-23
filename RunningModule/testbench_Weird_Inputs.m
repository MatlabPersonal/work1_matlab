data=importfile1('a08659c9-a59d-4254-b964-919de84e0ec5.csv');
Stc=data(:,1)*24*3600000;Ax1=data(:,2);Ax2=data(:,3);
%% Run Testbench 4 - Weird inputs
counter = 1; timeDelta = 100;
n=10; t=1000;
% (tic);
energyThreshold=10;
for i=1:n        
    movementType=randi(2,1,1);
    L=randi(3000,1,1);
    if(rem(i,2)==0)              
        dataStc = zeros(1,L);
        dataLeft = zeros(1,L);
        dataRight = zeros(1,L);
    else
        dataStc = (1:L)*10;
        dataLeft = rand(1,L);
        dataRight = rand(1,L);                
    end
%         
    dataStc=Stc';
    dataLeft=Ax1';
    dataRight=Ax2';

tic
        %% Run Gait Event Detection Algorithm
        [FootStrike_Left, FootStrike_Right, InitPeakAcc_Left, InitPeakAcc_Right, FlatFoot_Left, FlatFoot_Right, stSlope_Left, stSlope_Right, EdSlope_Left, EdSlope_Right, ToeOff_Left, ToeOff_Right,...
         dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right] =...
                                         findRunningEvents_V2(dataStc,dataLeft,dataRight,energyThreshold);%,k,i,m,team,counter);

        %% Run Metrics Algorithm
        BodyMass=80;
        [GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
         GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
         ContactTime_Left, ContactTimeVector_Left,...
         ContactTime_Right, ContactTimeVector_Right,...
         Speed, SpeedVector,Distance, DistanceVector,...
         Cadence, CadenceVector, RunTime, StrideNumber,...
         ASI,ASI_Vector] = ...
            estimateMetrics(dataStc, BodyMass,dataLeft, FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, EdSlope_Left, ToeOff_Left,...
                                               dataRight, FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, EdSlope_Right, ToeOff_Right,...
                                               dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right);%,...
%                                                        k,i,team,counter);
toc
        counter=counter+1;
%         clear data dataStc coeffs_Left swingWav_Left stanceWav_Left stanceWav_IPA_Left swingWavFilt_Left derivswingWav_Left indZeroSwingWav_Left locsSW_Left locsNegSW_Left locsST_Left locsNegST_Left locsNegIPA_ST_Left indZero_Left  derivAcc_Left  dataFilt_Left indFF_Left indIPA_Left indFS_Left indTO_Left FootStrike_Left  InitPeakAcc_Left  FlatFoot_Left  stSlope_Left  EdSlope_Left  GRF_Left  GRF_Vector_Left  IPA_Left  IPA_Vector_Left  ContactTime_Left  ContactTimeVector_Left  coeffs_Right swingWav_Right stanceWav_Right stanceWav_IPA_Right swingWavFilt_Right derivswingWav_Right indZeroSwingWav_Right locsSW_Right locsNegSW_Right locsST_Right locsNegST_Right locsNegIPA_ST_Right indZero_Right  derivAcc_Right  dataFilt_Right indFF_Right indIPA_Right indFS_Right indTO_Right FootStrike_Right  InitPeakAcc_Right  FlatFoot_Right  stSlope_Right  EdSlope_Right  GRF_Right  GRF_Vector_Right  IPA_Right  IPA_Vector_Right  ContactTime_Right  ContactTimeVector_Right ...                    
%                 Cadence  CadenceVector  Speed  SpeedVector  Distance  DistanceVector ...
%                 RunTime  StrideNumber;

end
display(counter)
