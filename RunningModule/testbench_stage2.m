%% load data
clear;
clc;
load('D:\Derek\Matlab\gait_study\algorithm\runningEventsDetection\MatlabFiles\data\VU gait study\data_OG.mat');


%% step - 1
[acc_left,acc_right,highg_left,highg_right,time] = synchroniseSensors(double(laccy'),double(raccy'),double(laccy'),double(raccy'),ltimeInterp,[lcursor(1) lcursor(end)],[rcursor(1) rcursor(end)]);

figure;
plot(acc_left); hold on;
plot(acc_right,'r');

%% step - 2
% range = 254400:255100;
range = 454026:466315;
[GRF_Left, GRF_Vector_Left,GRF_Right, GRF_Vector_Right] = ...
    GRFEstimatorLite(time(range)-time(range(1)),acc_left(range),acc_right(range),highg_left(range),highg_right(range),80);