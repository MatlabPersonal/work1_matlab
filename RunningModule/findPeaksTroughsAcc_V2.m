
function [derivAcc, dataFilt,troughsSpeed] = findPeaksTroughsAcc_V2(data, dataStc)
% Find all peaks and troughs of Accelerometer signal
derivAcc = diff(data)./diff(dataStc);

%% For model B of speed estimation
[B,A]=butter(4,6/(100/2),'low'); %the cut off feq was 6 before
% dataFilt = filtfilt(B,A,data);
temp=filtfilt(B,A,data);
dataFilt=reshape(temp,1,[]);

% This is to add 100 samples at the end so that the processing & displaying
% of the data in "chunks" uses the original amount of samples of the
% dataset
dataFilt = [dataFilt zeros(1,100)];
    
% Find troughs
MPH = 1;
if(all(-dataFilt<MPH))
        troughsSpeed=0;
else
MPD = 10;
    [~,troughsSpeed] = findpeaks(-dataFilt,'MinPeakDistance',MPD,'MinPeakHeight',MPH);
end


% figure;plot(dataFilt); hold on; plot(data,'g'); plot(troughsSpeed,dataFilt(troughsSpeed),'ro','linewidth',2);
% troughsSpeed = dataFilt(troughsSpeed);
% legend('data','trough');


if(isempty(troughsSpeed))
    troughsSpeed=0;
end
end