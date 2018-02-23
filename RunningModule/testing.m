clc;
clear;
load('D:\Derek\Matlab\Running\MatlabFiles\data\VU gait study\pelvic_tilt_test_LUK.mat');
%% Save data
pel_data_forTest = LSK_interp_highg(6662957:6795962,:);
pel_gyro_forTest = LSK_interp_gyro(6662957:6795962,:);
pel_data_right_forTest = RSK_interp_highg(6662957:6795962,:);
pel_gyro_right_forTest = RSK_interp_gyro(6662957:6795962,:);
time_forTest = timeInterp(6662957:6795962) - timeInterp(6662957);

n = length(pel_data_forTest(:,1))*100/(1000/mean(diff(time_forTest)));
pel_gyro_forTest = interp1(1:length(pel_data_forTest(:,1)),pel_gyro_forTest,linspace(1,length(pel_data_forTest(:,1)),n));
time_forTest = interp1(1:length(pel_data_forTest(:,1)),time_forTest,linspace(1,length(pel_data_forTest(:,1)),n));
pel_gyro_right_forTest = interp1(1:length(pel_data_forTest(:,1)),pel_gyro_right_forTest,linspace(1,length(pel_data_forTest(:,1)),n));
pel_data_right_forTest = interp1(1:length(pel_data_forTest(:,1)),pel_data_right_forTest,linspace(1,length(pel_data_forTest(:,1)),n));
pel_data_forTest = interp1(1:length(pel_data_forTest(:,1)),pel_data_forTest,linspace(1,length(pel_data_forTest(:,1)),n));

%%
% pel_data_forTest = pel_data_forTest(881300:1016000,:);
% pel_gyro_forTest = pel_gyro_forTest(881300:1016000,:);
% time_forTest = time_forTest(881300:1016000) - time_forTest(881300);
% n = length(pel_data_forTest(:,1))*100/(1000/mean(diff(time_forTest)));
% pel_gyro_forTest = interp1(1:length(pel_data_forTest(:,1)),pel_gyro_forTest,linspace(1,length(pel_data_forTest(:,1)),n));
% time_forTest = interp1(1:length(pel_data_forTest(:,1)),time_forTest,linspace(1,length(pel_data_forTest(:,1)),n));
% pel_data_forTest = interp1(1:length(pel_data_forTest(:,1)),pel_data_forTest,linspace(1,length(pel_data_forTest(:,1)),n));

%%

[roll,pitch,yaw] = runPelvicTiltAnalysis(pel_data_forTest,pel_gyro_forTest,time_forTest,CalRange);

figure;
plot(roll);