function [detectionRate] = findRatess(data, swingWav, stanceWav_IPA, stanceWav_IPADiff,...
                    FlatFoot,InitPeakAcc,FootStrike,ToeOff,...
                    FootStrike_True, InitPeakAcc_True, FlatFoot_True, stSlope_True, EdSlope_True, ToeOff_True)

% [~,I]=max(coeffs);
% FootStrike_Wav = I(FootStrike_True);
% InitPeakAcc_Wav = I(InitPeakAcc_True);
% FlatFoot_Wav = I(FlatFoot_True);
% stSlope__Wav = I(stSlope_True);
% EdSlope_Wav = I(EdSlope_True);
% ToeOff_Wav = I(ToeOff_True);

% swingWavFF = swingWav(FlatFoot_True);
% misWav_data_Out = swingWav(misLOCS_data_Out);
% lowFF = FlatFoot_True(find(abs(swingWavFF) < abs(2)));
% 
% Error
stillMisplaced = setdiff(FlatFoot_True,FlatFoot);
detected = setdiff(FlatFoot,FlatFoot_True);

%% Plot results
figure;
a(1)=subplot(2,1,1);
plot(data,'linewidth',2); hold on;%contour(coeffs,10);
plot(stanceWav_IPA*40,'r');
% plot(scales(maxScaleIDX),maxpercent,'k^','markerfacecolor',[0 0 0]);
plot(swingWav,'c','linewidth',3);
plot(stanceWav_IPADiff*40,'m--')

a(2)=subplot(2,1,2);
% plot(LOCS_Out,stanceWav_IPA(LOCS_Out)*40,'ko');
% plot(LOCS_data_Out, data(LOCS_data_Out),'go','linewidth',3);grid;
% plot(FlatFoot_True,data(FlatFoot_True),'r^','linewidth',2);
% plot(LOCS_Out,stanceWav_IPA(LOCS_Out)*20,'bo'); hold on;
% plot(FlatFoot_True,data(FlatFoot_True),'rx','linewidth',3);
% plot(LOCS_data_Out,data(LOCS_data_Out),'go');
% plot(misLOCS_data_Out,data(misLOCS_data_Out),'^k','linewidth',2);grid; 
% plot(CorrectedLOCS_data_Out,data(CorrectedLOCS_data_Out),'*r','linewidth',2); 
% plot(FlatFoot_True,swingWavFF,'r^');
% plot(misLOCS_data_Out,misWav_data_Out,'c^','linewidth',3);
% plot(CorrectedLOCS_data_Out,data(CorrectedLOCS_data_Out),'*r','linewidth',2);
% plot(stillMisplaced,data(stillMisplaced)+2,'co','linewidth',4)
% plot(FlatFoot_True,stanceWav_IPADiff(FlatFoot_True)*40,'rx','linewidth',2);
% plot(LOCS_data_Out,stanceWav_IPA(LOCS_data_Out)*40,'cx','linewidth',2);
% plot(lowFF,data(lowFF),'b^','linewidth',2)
% legend('LocsWav','True_{FF}','Detected_{FF}','misdetected','Corrected','SwingWavFF');
plot(data,'linewidth',2); hold on;
plot(FlatFoot,data(FlatFoot),'rx','linewidth',2); 
plot(FlatFoot_True,data(FlatFoot_True),'go','linewidth',2);

linkaxes(a,'x');

% Show detection rates
detectionRate = [100*(length(detected)/length(FlatFoot_True));100*(length(stillMisplaced)/length(FlatFoot_True))];

end