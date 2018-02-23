function plotMetrics(Stc,...
                GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ContactTime_Left, ContactTimeVector_Left,...
                GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ContactTime_Right, ContactTimeVector_Right,...                    
                ASI,ASI_Vector,Cadence, CadenceVector, Speed, SpeedVector, Distance, DistanceVector,...
                troughsSpeed_Left, troughsSpeed_Right, SpeedModel2, SpeedVectorModel2, DistanceModel2, DistanceVectorModel2,...
                RunTime, StrideNumber,...
                FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, EdSlope_Left, ToeOff_Left,...
                FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, EdSlope_Right, ToeOff_Right,...
                k,i,team,counter)

[B,A]=butter(4,0.01/1,'low');
Stc=Stc/1000;
%% 1-GRF
figure;
a(1)=subplot(2,3,1);
LA = length(GRF_Vector_Left); LB = length(GRF_Vector_Right); LC = length(ASI_Vector);
n = length(GRF_Vector_Left);

FlatFoot_Left = fix(interp1(1:length(FlatFoot_Left),FlatFoot_Left,linspace(1,length(FlatFoot_Left),n)));
FlatFoot_Right = fix(interp1(1:length(FlatFoot_Right),FlatFoot_Right,linspace(1,length(FlatFoot_Right),n)));

LA = FlatFoot_Left(1:LA); LB=FlatFoot_Right(1:LB); LC=FlatFoot_Right(1:LC);
plot(Stc(LA),GRF_Vector_Left,Stc(LB),GRF_Vector_Right,Stc(LC),ASI_Vector*100,'linewidth',2); grid;
% title(strcat(strcat(strcat(strcat('Team:',team{i}),'-'),'Player:'),num2str(k)));
legend('Left','Right','ASI(%)/100'); ylabel('GRF(N)'); xlabel('seconds');
%axis([Stc(LA(1))-5 Stc(LA(end))+5 1000 2500]);

% dlmwrite('GRF_L.csv',[Stc(LA)' filtfilt(B,A,GRF_Vector_Left)'],'precision',10);
% dlmwrite('GRF_R.csv',[Stc(LB)' filtfilt(B,A,GRF_Vector_Right)'],'precision',10);
% dlmwrite('ASI.csv',[Stc(LC)' filtfilt(B,A,ASI_Vector)'],'precision',10);
 
%% 2-IPA

InitPeakAcc_Left = fix(interp1(1:length(InitPeakAcc_Left),InitPeakAcc_Left,linspace(1,length(InitPeakAcc_Left),n)));
InitPeakAcc_Right = fix(interp1(1:length(InitPeakAcc_Right),InitPeakAcc_Right,linspace(1,length(InitPeakAcc_Right),n)));
a(2)=subplot(2,3,4);
LA = length(IPA_Vector_Left); LB = length(IPA_Vector_Right);
LA = InitPeakAcc_Left(1:LA); LB=InitPeakAcc_Right(1:LB);
plot(Stc(LA),IPA_Vector_Left,Stc(LB),IPA_Vector_Right,'linewidth',2); grid;
ylabel('IPA(g)');  xlabel('seconds');

% dlmwrite('IPA_L.csv',[Stc(LA)' filtfilt(B,A,IPA_Vector_Left)'],'precision',10);
% dlmwrite('IPA_R.csv',[Stc(LB)' filtfilt(B,A,IPA_Vector_Right)'],'precision',10);
%% 3- Contact Time
a(3)=subplot(2,3,2);
% LA = FootStrike_Left(1:LA); LB=FootStrike_Right(1:LB);
FootStrike_Left = fix(interp1(1:length(FootStrike_Left),FootStrike_Left,linspace(1,length(FootStrike_Left),n)));
FootStrike_Right = fix(interp1(1:length(FootStrike_Right),FootStrike_Right,linspace(1,length(FootStrike_Right),n)));

LA = linspace(Stc(FootStrike_Left(1)),Stc(FootStrike_Left(end)),length(ContactTimeVector_Left));
LB = linspace(Stc(FootStrike_Right(1)),Stc(FootStrike_Right(end)),length(ContactTimeVector_Right));
plot(LA,ContactTimeVector_Left,LB,ContactTimeVector_Right,'linewidth',2); grid;
ylabel('CT(ms)'); xlabel('seconds');

% dlmwrite('GCT_L.csv',[LA' filtfilt(B,A,ContactTimeVector_Left)'],'precision',10);
% dlmwrite('GCT_R.csv',[LB' filtfilt(B,A,ContactTimeVector_Right)'],'precision',10);
%% 4- Cadence and Speed
a(4)=subplot(2,3,5);
EdSlope_Left = fix(interp1(1:length(EdSlope_Left),EdSlope_Left,linspace(1,length(EdSlope_Left),n)));
troughsSpeed_Right = fix(interp1(1:length(troughsSpeed_Right),troughsSpeed_Right,linspace(1,length(troughsSpeed_Right),n)));

LA = linspace(Stc(EdSlope_Left(1)),Stc(EdSlope_Left(end)),length(CadenceVector));
LC = linspace(Stc(troughsSpeed_Left(1)),Stc(troughsSpeed_Left(end)),length(SpeedVectorModel2));
plot(LA,CadenceVector/10,LC,SpeedVectorModel2,'linewidth',2); grid; %"10" just to be displayed in the same graph
legend('Cad(sps/min)/10','Speed(km/h)','Speed(km/h) V2'); xlabel('seconds');

% dlmwrite('cadence.csv',[LA' filtfilt(B,A,CadenceVector)'],'precision',10);
% dlmwrite('speed.csv',[LC' filtfilt(B,A,SpeedVectorModel2)'],'precision',10);
%% 5- Distance
a(5)=subplot(2,3,3);
LB = linspace(Stc(troughsSpeed_Left(1)),Stc(troughsSpeed_Left(end)),length(DistanceVectorModel2)); 
plot(LB,DistanceVectorModel2,'linewidth',2);  grid;
legend('Distance','Distance V2'); xlabel('seconds');
linkaxes(a,'x');

% dlmwrite('distance.csv',[LB' filtfilt(B,A,DistanceVectorModel2)'],'precision',10);
%% 6- Table
cnames = {'Left','Right'};
rnames = {'GRF(N)','ASI(%)','IPA(g)','CT(ms)','Cadence(sps/min)','Speed(km/h)','Speed V2(km/h)','Distance(m)','Distance V2(m)','RunTime (s)','StrideNumber','SD1','SD2'};
stats = [GRF_Left GRF_Right;...
         ASI,0;...
         IPA_Left IPA_Right;...
         ContactTime_Left ContactTime_Right;...
         Cadence 0;...
         Speed 0;...
         SpeedModel2 0;...
         Distance 0;...
         DistanceModel2 0;...
         RunTime 0; ...
         StrideNumber 0;...
         0 0];
uitable('Data',stats,'ColumnName',cnames,... 
        'RowName',rnames,'Position',[1100 100 330 220]);
    
% display(strcat('L:',num2str(ContactTime_Left)))
% display(strcat('R:',num2str(ContactTime_Right)))
% display(strcat('D:',num2str(Distance)))


end