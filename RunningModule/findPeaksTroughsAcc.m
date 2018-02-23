
function [indZero, derivAcc, dataFilt,troughsSpeed] = findPeaksTroughsAcc(data, dataStc)

%% Find all peaks and troughs of Accelerometer signal
derivAcc = diff(data)./diff(dataStc);

%derivAccFilt = diff(dataFilt)./diff(dataStc);
indZero=crossing(derivAcc);
%indZeroFilt=crossing(derivAccFilt);
indZero=indZero+1;
%indZeroFilt=indZeroFilt+1;

%% For model B of speed estimation
[B,A]=butter(4,6/(100/2),'low');
dataFilt = filtfilt(B,A,data);

% Find troughs
MPD = 30;
[~,troughsSpeed] = findpeaks(-dataFilt,'MinPeakDistance',MPD,'MinPeakHeight',2);
% figure;plot(dataFilt); hold on; plot(data,'g'); plot(troughsSpeed,dataFilt(troughsSpeed),'ro','linewidth',2);
% troughsSpeed = dataFilt(troughsSpeed);
% legend('data','trough');

end