function [swingWav, stanceWav_IPA,coeffs] = calculateCWT_V2(data)    

% Calculate wavelets
scales = 1:64;
% coeffs = cwtCustomized(data,scales,'sym3');

%% FF  - Automatic FF detection with sym3 
% coeffs = cwt(data,scales,'sym3');
coeffs = cwtCustomized(data,4,'sym3');
stanceWav_IPA = coeffs/max(max(abs(coeffs)));
% stanceWav_IPA = coeffs/max(max(abs(coeffs)));
[B,A]=butter(4,0.8/(100/2),'low');  %derek: large filter for finding sinusoid swing wav in low speeds 
% in the above line, cut off freq 1 works for 4km/h and higher, 0.8 seems better for 2km/h, needs validation
coeffs = cwtCustomized(filtfilt(B,A,data),scales,'db5');

%% Swing - Automatic Swing detection with energy detection using db5 wavelets
energy = sqrt(sum(abs(coeffs).^2,2));
percentage = 100*energy/sum(energy);
[~,maxScaleIDX] = max(percentage);
swingWav = coeffs(scales(maxScaleIDX),:)/max(max(abs(coeffs)))*20;
[B,A]=butter(2,5/(100/2),'low');
temp = filtfilt(B,A,swingWav);
swingWav = reshape(temp,1,[]);

% plot(scales,percentage,'.-r');
%dataDiff = diff(data)./diff(dataStc);