clear;
clc;

filename = 'D:\Derek\Matlab\ProcessBinDLL\bugfiles\mdm5086-4.bin';
m = memmapfile(filename);
A = m.Data;
% profile -memory on
tic
[acc,gyro,mag,high_g_acc,high_speed_gyro,emg,...
    battery_voltage,battery_soc,acc_temp,mag_temp,...
    timeTZ,timeHighG,timeHsGyro,timeEmg] = qu_file_v6c(filename);
toc
% profile viewer

figure;
plot(timeTZ,acc(:,2)); hold on;
% plot(timeEmg,emg,'r');
plot(timeHighG,-high_g_acc(:,2),'r');

