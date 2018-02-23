function [locsSW,locsST,locsNegIPA_ST,indZeroSwingWav,derivSwingWav,locsDataIPA] = findPeaksWav_V2(swingWav,stanceWav,stanceWav_IPA,Stc,data)

% Find peaks
MPD = 40;
[~,locsSW] = findpeaks(swingWav,'MinPeakDistance',MPD,'MinPeakHeight',1.0);

MPD = 30;
[~,locsST] = findpeaks(stanceWav,'MinPeakDistance',MPD,'MinPeakHeight',0.3);

MPD = 25;
[~,locsNegIPA_ST] = findpeaks(-stanceWav_IPA,'MinPeakDistance',MPD,'MinPeakHeight',0.5);

MPD = 10;
[~,locsDataIPA] = findpeaks(-data);
%locsDataIPA(1:20)=30;

%% Filter peaks
% Filter FF
derivSwingWav = (diff(swingWav)./diff(Stc));
%locsST(derivSwingWav(locsST) < 0)=[];
locsST(swingWav(locsST) > 1.5)=[];

indZeroSwingWav=crossing(swingWav)';
indZeroSwingWav(derivSwingWav(indZeroSwingWav) > 0)=[];% If derivative is positive, then exclude

% Filter StSlope (locsSW) & EdSlope (indZeroSwingWav)
indZeroSwingWav(data(indZeroSwingWav) < -3)=[];% If data is negative, then exclude
indZeroSwingWav(derivSwingWav(indZeroSwingWav) > -0.03)=[]; % Look at the derivative of the SwingWav and check its change rate
locsSW=locsSW';

L=length(indZeroSwingWav);temp=zeros(1,L);
for k=1:L    
    if(~isempty(max(locsSW(find(indZeroSwingWav(k) > locsSW))))) %<FIXME: Move this to findEvents?>
        temp(k) = max(locsSW(find(indZeroSwingWav(k) > locsSW)));
    end
end
locsSW=temp(1:k); %clear temp; % This is actually the StSlope
indZeroSwingWav(locsSW==0)=[]; % Start of Slope and End of Slope have to be in order
locsSW(locsSW==0)=[]; % Start of Slope and End of Slope have to be the same


% Filter IPA (locsNegIPA_ST)
indZeroSwingWav=indZeroSwingWav';
locsNegIPA_ST(swingWav(locsNegIPA_ST) < 0)=[];

%% Plot peaks/troughs
%  
% figure;
% plot(data,'linewidth',2); hold on;plot(locsDataIPA,data(locsDataIPA),'co','linewidth',2);
% plot(locsNegIPA_ST,data(locsNegIPA_ST),'rx');
% plot(swingWav,'r');plot(stanceWav_IPA,'g');plot(locsNegIPA_ST,stanceWav_IPA(locsNegIPA_ST),'bo');

end