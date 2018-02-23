function [FootStrike_Wav,InitPeakAcc_Wav, FlatFoot_Wav, stSlope__Wav, EdSlope_Wav, ToeOff_Wav, detectionRate] = calculateCWT_Test(data,dataStc, FootStrike_True, InitPeakAcc_True, FlatFoot_True, stSlope_True, EdSlope_True, ToeOff_True)    

% Calculate wavelets
scales = 1:64;
coeffs = cwtCustomized(data,scales,'db3');

%% Test with db3 and db5 Wavelets
coeffs = cwt(data,scales,'sym3');
[~,I]=max(coeffs);
FootStrike_Wav = I(FootStrike_True);
InitPeakAcc_Wav = I(InitPeakAcc_True);
FlatFoot_Wav = I(FlatFoot_True);
stSlope__Wav = I(stSlope_True);
EdSlope_Wav = I(EdSlope_True);
ToeOff_Wav = I(ToeOff_True);

stanceWav_IPA = coeffs(4,:)/max(max(abs(coeffs)));
coeffs = cwt(data,scales,'db5');
%coeffsSwingDb3 = cwt(data,scales,'db3');
coeffsSwingDb3 = coeffs(50,:);

energy = sqrt(sum(abs(coeffsSwingDb3).^2,2));
percentage = 100*energy/sum(energy);[maxpercent,maxScaleIDX] = max(percentage);
swingWav2 = coeffsSwingDb3(scales(maxScaleIDX),:)/max(max(abs(coeffs)))*20;

figure;
a(1)=subplot(2,1,1);
plot(data,'linewidth',2); hold on;%contour(coeffs,10);
plot(stanceWav_IPA*40,'r');



energy = sqrt(sum(abs(coeffs).^2,2));
percentage = 100*energy/sum(energy);plot(scales,percentage,'.-r');
[maxpercent,maxScaleIDX] = max(percentage);


plot(scales(maxScaleIDX),maxpercent,'k^','markerfacecolor',[0 0 0])


swingWav = coeffs(scales(maxScaleIDX),:)/max(max(abs(coeffs)))*20;
[B,A]=butter(2,5/(100/2),'low');
swingWav = filtfilt(B,A,swingWav);


plot(swingWav,'c','linewidth',3);
plot(swingWav2,'b--','linewidth',3)
%stanceWav_IPADiff = diff(stanceWav_IPA*40)./diff(dataStc);
stanceWav_IPADiff = diff(data)./diff(dataStc);


plot(stanceWav_IPADiff*40,'m--')

%% 1. Find negative swing
indZeroSwingWav=crossing(swingWav)';

% Make sure it is negative
k=1; counterMisdetected = 1;misLOCS_data_Out=[];CorrectedLOCS_data_Out=[];LOCS_data_Out=[];
if swingWav(indZeroSwingWav(1)+1)<0
   start = 1;
else start = 2;
end
for i=start:2:length(indZeroSwingWav)-1
    %% 2. Find the maximum peaks within that region
   
    delta = indZeroSwingWav(i):indZeroSwingWav(i+1);
    %[~,maxWavIDX]=max(stanceWav_IPA(delta));        

    %[~,LOCS]=findpeaks(stanceWav_IPA(delta));
    if (length(delta) > 3)
    [~,LOCS]=findpeaks(stanceWav_IPADiff(delta));
    
    %figure;
    %plot(stanceWav_IPA(delta)); hold on;
    %plot(LOCS,stanceWav_IPA(delta(LOCS)),'rx');
    locsPercentage = LOCS/length(delta);

    %% 3. Exclude the ones that are not in a specific range (0 - 55% of the negative area of swing phase)
    LOCS(locsPercentage>1.0)=[];
    LOCS(locsPercentage<0.2)=[];
    
    %plot(LOCS,stanceWav_IPA(delta(LOCS)),'ko');

    %[Y,I] = sort(stanceWav_IPA(delta(LOCS)),'descend');
    [~,I] = sort(stanceWav_IPADiff(delta(LOCS)),'descend');
    
        %if (length(LOCS)>=2)
        if (length(LOCS) >= 1)
            %display(i);
            %LOCS_Out(k) = LOCS(2); % Check only the first two
            LOCS_Out(k) = LOCS(I(1)); % Check only the first two
            %plot(LOCS_Out,stanceWav_IPA(delta(LOCS_Out)),'go');
            LOCS_Out(k) = LOCS_Out(k) + indZeroSwingWav(i) - 1;

            %% 4. Find the Flat Foot Event that comes near that positive peak
            tempDelta = length(delta) - LOCS(I(1));
            if(tempDelta>3)
                [~,LOCS_data]=findpeaks(data(LOCS_Out(k):LOCS_Out(k)+tempDelta-1),'NPeaks',1);                
                if(~isempty(LOCS_data))
                    %[~,I] = sort(data(temp(tempLOCS)),'descend');
                    %LOCS_data = tempLOCS(1);
                    
                    LOCS_data_Out(k) = LOCS_data+LOCS_Out(k)-1;                                    
                    %% 5. Fix misdetected ones
                    %temp = LOCS_data_Out(k) - (indZeroSwingWav(i) +1 + LOCS_data);
                    temp = LOCS_data_Out(k) - (indZeroSwingWav(i));
                    %display(i);display(k);
                    percentageLOCS(k) = temp/length(delta);
                    if ((percentageLOCS(k) > 1.0) && data(delta(temp)) < 0)
                        misLOCS_data_Out(counterMisdetected) =  LOCS_data_Out(k);
                        %display(misLOCS_data_Out(counterMisdetected));

                        % Use the other peak 
                        if(length(I)>=2)
                            LOCS_Out(k) = LOCS(I(2));  LOCS_Out(k) = LOCS_Out(k) + indZeroSwingWav(i) - 1;
                            [~,LOCS_data]=findpeaks(data(LOCS_Out(k):LOCS_Out(k)+3),'NPeaks',1);
                            if(~isempty(LOCS_data))
                                LOCS_data_Out(k) = LOCS_data+LOCS_Out(k)-1;
                                 CorrectedLOCS_data_Out(counterMisdetected) = LOCS_data_Out(k);
                                 counterMisdetected = counterMisdetected + 1;

                            end
                        end
                    else

                    end               
                end             
                k=k+1;
            end

        end

    end
end

LOCS_data_Out(LOCS_data_Out==0)=[];
%percentageLOCS(percentageLOCS==0)=[];
LOCS_data_Out = sort(LOCS_data_Out);
LOCS_Out = sort(LOCS_Out);

LOCS_Out(LOCS_Out < FlatFoot_True(1)) = [];
LOCS_Out(LOCS_Out > FlatFoot_True(end)) = [];

LOCS_data_Out(LOCS_data_Out < FlatFoot_True(1)) = [];
LOCS_data_Out(LOCS_data_Out > FlatFoot_True(end)) = [];


plot(LOCS_Out,stanceWav_IPA(LOCS_Out)*40,'ko');
plot(LOCS_data_Out, data(LOCS_data_Out),'go','linewidth',3);grid;
plot(FlatFoot_True,data(FlatFoot_True),'r^','linewidth',2);

a(2)=subplot(2,1,2);
plot(LOCS_Out,stanceWav_IPA(LOCS_Out)*20,'bo'); hold on;
plot(FlatFoot_True,data(FlatFoot_True),'rx','linewidth',3);
plot(LOCS_data_Out,data(LOCS_data_Out),'go');
plot(misLOCS_data_Out,data(misLOCS_data_Out),'^k','linewidth',2);grid; 
plot(CorrectedLOCS_data_Out,data(CorrectedLOCS_data_Out),'*r','linewidth',2); 

swingWavFF = swingWav(FlatFoot_True);
misWav_data_Out = swingWav(misLOCS_data_Out);

plot(FlatFoot_True,swingWavFF,'r^');
plot(misLOCS_data_Out,misWav_data_Out,'c^','linewidth',3);
plot(CorrectedLOCS_data_Out,data(CorrectedLOCS_data_Out),'*r','linewidth',2);

stillMisplaced = setdiff(FlatFoot_True,LOCS_data_Out);
detected = setdiff(LOCS_data_Out,FlatFoot_True);
plot(stillMisplaced,data(stillMisplaced)+2,'co','linewidth',4)

stillMisplaced = setdiff(FlatFoot_True,LOCS_data_Out);
plot(FlatFoot_True,stanceWav_IPADiff(FlatFoot_True)*40,'rx','linewidth',2);
plot(LOCS_data_Out,stanceWav_IPA(LOCS_data_Out)*40,'cx','linewidth',2);

%plot(LOCS_data_Out,percentageLOCS*10,'ko','linewidth',4)
%plot(LOCS_data_Out,percentageLOCS*100,'kx','linewidth',2);

lowFF = FlatFoot_True(find(abs(swingWavFF) < abs(2)));
plot(lowFF,data(lowFF),'b^','linewidth',2)

legend('LocsWav','True_{FF}','Detected_{FF}','misdetected','Corrected','SwingWavFF');

if 0
a(3)=subplot(1,2,2);
plot(LOCS_data_Out,data(LOCS_data_Out),'go','linewidth',2); hold on;
plot(FlatFoot_True,data(FlatFoot_True),'rx','linewidth',2);grid;
plot(data);
end

linkaxes(a,'x');

%igure; plot(data);hold on;plot(LOCS_data_Out,data(LOCS_data_Out),'ro','linewidth',2);

% Show detection rates
detectionRate = [100*(length(detected)/length(FlatFoot_True));100*(length(stillMisplaced)/length(FlatFoot_True))];


