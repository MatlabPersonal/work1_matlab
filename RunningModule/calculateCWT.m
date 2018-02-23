function [swingWav,stanceWav,stanceWav_IPA,coeffs] = calculateCWT(data,dataStc)    

% Calculate wavelets
scales = 1:64;
%scales = [1 4 50];
coeffs = cwtCustomized(data,scales,'db3');
swingWav = -coeffs(50,:)/max(max(abs(coeffs)))*20;
stanceWav = coeffs(1,:)/max(max(abs(coeffs)))*50;
stanceWav_IPA = coeffs(4,:)/max(max(abs(coeffs)))*40;

% swingWav = -coeffs(3,:)/max(max(abs(coeffs)))*20;
% stanceWav = coeffs(1,:)/max(max(abs(coeffs)))*50;
% stanceWav_IPA = coeffs(2,:)/max(max(abs(coeffs)))*40;
%swingWav = swingWav';
[B,A]=butter(4,5/(100/2),'low');
temp=filtfilt(B,A,swingWav); %<FIXME: Coder reports error here>
swingWav = reshape(temp,1,[]);



%% Get CWT coeffs for perfect Gait Events



