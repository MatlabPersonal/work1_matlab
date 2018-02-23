function plotWavelets(Stc, data_Left,swingWav_Left,stanceWav_IPA_Left, dataFilt_Left,FootStrike_Left, InitPeakAcc_Left, FlatFoot_Left, stSlope_Left, EdSlope_Left, ToeOff_Left,troughsSpeed_Left,...
                           data_Right,swingWav_Right,stanceWav_IPA_Right, dataFilt_Right,FootStrike_Right, InitPeakAcc_Right, FlatFoot_Right, stSlope_Right, EdSlope_Right,ToeOff_Right,troughsSpeed_Right,...
                           energy_Left,energy_Right,energyFiltLeft,energyFiltRight)%,...
%                            k,i,m,team,counter)

%% 1- Wavelets map
figure;
% a(1)=subplot(2,3,1);
% %contour(coeffs_Left,5); hold on;
% plot(data_Left-10,'linewidth',2);
% axis([1 length(data_Left) -50 65]); grid;
% ylabel('Left');
% title(strcat(strcat(strcat(strcat('Team:',team{i}),'-'),'Player:'),num2str(k)));
% legend('Wavelets Map');
% 
% a(2)=subplot(2,3,4);
% %contour(coeffs_Right,5); hold on;
% plot(data_Right-10,'linewidth',2);
% axis([1 length(data_Right) -50 65]); grid;
% ylabel('Right'); xlabel('samples');

%% 2- Wavelets 
%a(3)=subplot(2,3,2);                        
a(1)=subplot(2,2,1);                        
plot(data_Left*50,'linewidth',2); hold on;
plot(swingWav_Left,'r','linewidth',2);
% plot(indZeroSwingWav_Left,swingWav_Left(indZeroSwingWav_Left),'b*','linewidth',2);
% plot(stanceWav_Left,'g','linewidth',2);    
plot(stanceWav_IPA_Left,'k-','linewidth',1);
% plot(locsSW_Left,swingWav_Left(locsSW_Left),'ko','linewidth',2);
%plot(locsNegSW_Left,swingWav_Left(locsNegSW_Left),'co','linewidth',2);    
% plot(locsST_Left,stanceWav_Left(locsST_Left),'ro','linewidth',2);
%plot(locsNegST_Left,stanceWav_Left(locsNegST_Left),'k^','linewidth',2);    
% plot(locsNegIPA_ST_Left,stanceWav_IPA_Left(locsNegIPA_ST_Left),'mo','linewidth',2);                     
plot(dataFilt_Left,'r');
%plot(derivswingWav_Left*30,'c','linewidth',2);
%plot((derivswingWav_Left(indZeroSwingWav_Left)*30),'yo');
plot(troughsSpeed_Left,dataFilt_Left(troughsSpeed_Left),'go','linewidth',3)
plot(energy_Left,'c','linewidth',3);
plot(energyFiltLeft,'k--','linewidth',1);
legend('acc Left','swingWav Left','stanceWav IPA Left','dataFilt Left','troughsSpeed Left','energy Left','energyFiltLeft');
% title('Wavelets db3 - daughters'); ylabel(strcat(strcat(strcat('Player:',num2str(k)),'/Run-Through:'),num2str(m))); xlabel(strcat('Team:',team{i}));
grid;   

%a(4)=subplot(2,3,5);                        
a(2)=subplot(2,2,3);                        
plot(data_Right*50,'linewidth',2); hold on;
plot(swingWav_Right,'r','linewidth',2);
% plot(indZeroSwingWav_Right,swingWav_Right(indZeroSwingWav_Right),'b*','linewidth',2);
% plot(stanceWav_Right,'g','linewidth',2);    
plot(stanceWav_IPA_Right,'k-','linewidth',1);
% plot(locsSW_Right,swingWav_Right(locsSW_Right),'ko','linewidth',2);
%plot(locsNegSW_Right,swingWav_Right(locsNegSW_Right),'co','linewidth',2);    
% plot(locsST_Right,stanceWav_Right(locsST_Right),'ro','linewidth',2);
%plot(locsNegST_Right,stanceWav_Right(locsNegST_Right),'k^','linewidth',2);    
% plot(locsNegIPA_ST_Right,stanceWav_IPA_Right(locsNegIPA_ST_Right),'mo','linewidth',2);                     
plot(dataFilt_Right,'r');
%plot(derivswingWav_Right*30,'c','linewidth',2);
%plot((derivswingWav_Right(indZeroSwingWav_Right)*30),'yo');
plot(troughsSpeed_Right,dataFilt_Right(troughsSpeed_Right),'go','linewidth',3)
plot(energy_Right,'c','linewidth',3);
plot(energyFiltRight,'k--','linewidth',1);
xlabel('samples');
grid;      

%% 3- Gait Events - Left
%a(5)=subplot(2,3,3);
a(3)=subplot(2,2,2);
% Left
Stc=Stc/1000;
plot(data_Left); hold on;                  
plot(FootStrike_Left,data_Left(FootStrike_Left),'go','linewidth',3);
plot(InitPeakAcc_Left,data_Left(InitPeakAcc_Left),'yo','linewidth',3);
plot(FlatFoot_Left,data_Left(FlatFoot_Left),'k*','linewidth',3);
plot(stSlope_Left,data_Left(stSlope_Left),'r*','linewidth',3);
plot(EdSlope_Left,data_Left(EdSlope_Left),'co','linewidth',3);
plot(ToeOff_Left,data_Left(ToeOff_Left),'mo','linewidth',3);

legend('Acc','FS','IPA','FF','StSlope','EdSlope','TO');
title('Events');
grid;

%% 4- Gait Events - Right
%a(6)=subplot(2,3,6);
a(4)=subplot(2,2,4);
% Right
plot(data_Right); hold on;                  

plot(FootStrike_Right,data_Right(FootStrike_Right),'go','linewidth',3);
plot(InitPeakAcc_Right,data_Right(InitPeakAcc_Right),'yo','linewidth',3);
plot(FlatFoot_Right,data_Right(FlatFoot_Right),'k*','linewidth',3);
plot(stSlope_Right,data_Right(stSlope_Right),'r*','linewidth',3);
plot(EdSlope_Right,data_Right(EdSlope_Right),'co','linewidth',3);
plot(ToeOff_Right,data_Right(ToeOff_Right),'mo','linewidth',3);

% xlabel(strcat('RunTrough:',num2str(counter))); grid;
xlabel('samples');
linkaxes(a,'x');



end