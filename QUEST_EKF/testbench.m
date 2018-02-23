clear;
load('D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\sensor6_downsampled_all.mat');
load('D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\cal_coeff\cal_S6.mat');
%read subject
clc;
frequency = [226 128 64 32 25 20 16 8];
freqIndex = 1;
Subject = 2;
%s6
dataS6 = s6down{Subject,freqIndex};
s6.time = dataS6(:,1);
s6.accX = dataS6(:,2);
s6.accY = dataS6(:,3);
s6.accZ = dataS6(:,4);
s6.gyroX = dataS6(:,5);
s6.gyroY = dataS6(:,6);
s6.gyroZ = dataS6(:,7);
magx = dataS6(:,8);
magy = dataS6(:,9);
magz = dataS6(:,10);

s6.accCalX_k = s6_p_acc(1,1);
s6.accCalX_b = s6_p_acc(1,2);
s6.accCalY_k = s6_p_acc(2,1);
s6.accCalY_b = s6_p_acc(2,2);
s6.accCalZ_k = s6_p_acc(3,1);
s6.accCalZ_b = s6_p_acc(3,2);
s6.gyroCalX_k = s6_p_gyro(1,1);
s6.gyroCalX_b = s6_p_gyro(1,2);
s6.gyroCalY_k = s6_p_gyro(2,1);
s6.gyroCalY_b = s6_p_gyro(2,2);
s6.gyroCalZ_k = s6_p_gyro(3,1);
s6.gyroCalZ_b = s6_p_gyro(3,2);


s6.accXCal = s6.accCalX_k.*s6.accX + s6.accCalX_b;
s6.accYCal = s6.accCalY_k.*s6.accY + s6.accCalY_b;
s6.accZCal = s6.accCalZ_k.*s6.accZ + s6.accCalZ_b;

s6.gyroXCal = s6.gyroCalX_k.*s6.gyroX + s6.gyroCalX_b;
s6.gyroYCal = s6.gyroCalY_k.*s6.gyroY + s6.gyroCalY_b;
s6.gyroZCal = s6.gyroCalZ_k.*s6.gyroZ + s6.gyroCalZ_b;

% s6.accXCal = acc(:,1);
% s6.accYCal = acc(:,2);
% s6.accZCal = acc(:,3);
% 
% s6.gyroXCal = gyro(:,1);
% s6.gyroYCal = gyro(:,2);
% s6.gyroZCal = gyro(:,3);

% s6.time = timeInterp;

% [q0Out,q1Out,q2Out,q3Out,roll,pitch,yaw] = AttitudeQuatKalmanFilter(s6.gyroXCal',s6.gyroYCal',s6.gyroZCal',s6.accXCal',s6.accYCal',s6.accZCal',magx',magy',magz',s6.time',0.5,0.05,0.005,0.01,1);
calRange = 1;
[q0,q1,q2,q3,roll,pitch,yaw] = runAttitudeEstimator(s6.gyroXCal',s6.gyroYCal',s6.gyroZCal',s6.accXCal',s6.accYCal',s6.accZCal',magx',magy',magz',s6.time',0);
[q0,q1,q2,q3,rollOut,pitchOut,yawOut] = runQuaternionCalibrator(q0,q1,q2,q3,calRange);
[q0d,q1d,q2d,q3d,rolld,pitchd,yawd] = runAttitudeEstimator(s6.gyroXCal',s6.gyroYCal',s6.gyroZCal',s6.accXCal',s6.accYCal',s6.accZCal',magx',magy',magz',s6.time',2);
[q0d,q1d,q2d,q3d,rollOut,pitchOut,yawOut] = runQuaternionCalibrator(q0d,q1d,q2d,q3d,calRange);
[q0j,q1j,q2j,q3j,roll_j,pitch_j,yaw_j] = runJointAngleCalculator(q0,q1,q2,q3,q0,q1,q2,q3);
[q0f,q1f,q2f,q3f,rollf,pitchf,yawf] = runMotionIntensityClassfier(q0,q1,q2,q3,q0d,q1d,q2d,q3d,s6.accXCal',226);
plot(yawf);