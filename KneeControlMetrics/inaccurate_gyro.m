%% load data
clear;
clc;
[NUM,TXT,~] = xlsread('D:\Derek\Matlab\boxdrop\MatlabFiles\inaccurate_gyro_speed\bec-bryce-bentvelezen-box-drop-right-leg-lead.csv');

%% process

NUM = [zeros(size(NUM,1),1) NUM];
acc1 = [NUM(:,3) NUM(:,4) NUM(:,5)];
gyro1 = [NUM(:,6) NUM(:,7) NUM(:,8)];
acc2 = [NUM(:,9) NUM(:,10) NUM(:,11)];
gyro2 = [NUM(:,12) NUM(:,13) NUM(:,14)];
[~,speed1]=vt(gyro1(:,2),gyro1(:,3),45);
[~,speed2]=vt(gyro2(:,2),gyro2(:,3),-45);
figure;
subplot(2,1,1);
plot(speed1);
subplot(2,1,2);
plot(speed2);
% figure;
% subplot(2,1,1);
% plot(speed2);
% subplot(2,1,2);
% plot(gyro2);
%% speed vector

