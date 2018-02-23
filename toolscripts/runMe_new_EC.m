%% Init variables and decode data
clc;
clear; close all;
filename = 'D:\Derek\Matlab\toolscripts\mdm0063.bin';
[raw_data,acc,gyro,emg,hsGyro,high_g_acc,battery_soc,battery_voltage,time,timeIndex,timeInterp,acc_temp,mag_temp,page_info] = qu_file_V6c_new(filename);

%% Filtering
[B,A] = butter(8,20/500,'high');
[B1,A1] = butter(8,100/500,'low');
[B2,A2] = butter(8,20/500,'low');
emg_filtered_H = filtfilt(B,A,emg);
emg_filtered = filtfilt(B1,A1,emg_filtered_H);
emg_filtered_envelope = filtfilt(B2,A2,abs(emg_filtered));

%% Plot EMG and acc data
emg_time = interp1(1:length(timeInterp),timeInterp,linspace(1,length(timeInterp),length(emg)));
figure;
plot(timeInterp/60/1000,10*acc(:,3)-8,'r'); hold on;
% plot(emg_time,30*emg_filtered,'k'); hold on;
plot(emg_time/60/1000,80*emg_filtered,'k'); hold on;
plot(emg_time/60/1000,100*emg_filtered_envelope,'c'); hold on;
plot(emg_time/60/1000,10*emg,'b');
axis([0 length(emg)/60/1000 -40 30])
grid;

%% Plot FFT
% figure;
% Fs = 1000/mean(diff(emg_time));
% L = length(emg_filtered);
% f = Fs*(0:(L-1))/L;
% Y = fft(emg_filtered);
% pow = Y.*conj(Y);
% plot(f,pow) 
% title('Single-Sided Amplitude Spectrum of X(t)')
% xlabel('f (Hz)')
% ylabel('|P1(f)|')
