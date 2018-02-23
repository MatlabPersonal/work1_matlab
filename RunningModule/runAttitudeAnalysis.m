function [PEL_FX,PEL_LFX,LSK_FX,LSK_LFX,RSK_FX,RSK_LFX] = runAttitudeAnalysis(acc,gyro,time,CalRange,acc2,gyro2,acc3,gyro3)

% Pelvic Tilt
[B,A] = butter(5,5/450,'low');
accnorm = normaliseAcc(acc);
FX_angle = 0.2*atan2(accnorm(:,3),-accnorm(:,1))*180/pi;
LFX_angle = atan2(-accnorm(:,2),sqrt(accnorm(:,3).^2 + accnorm(:,1).^2))*180/pi;
PelQuatHigh = angle2quatInverted(-filtfilt(B,A,LFX_angle)*pi/180,-filtfilt(B,A,FX_angle)*pi/180,zeros(1,length(FX_angle)),'xyz');
gyroreorder = -[gyro(:,3),gyro(:,2),gyro(:,1)];
PelQuatHighEKF = AttitudeQuatKalmanFilter(gyroreorder,PelQuatHigh,time,0.5,0.005,0.005,0.01,1);
calQuatTemp = mean(PelQuatHighEKF(CalRange,1:4));
quatCal = quatmult((PelQuatHighEKF(:,1:4)),quatconj(calQuatTemp))';
[roll,pitch,~] = quat2angle2Inverted(quatCal,'xyz');

% Dynamic Valgus Left
% LFX
acc2norm = normaliseAcc(acc2);
FX_angle2 = atan2(acc2norm(:,3),sqrt(acc2norm(:,2).^2 + acc2norm(:,1).^2))*180/pi;
LFX_angle2 = atan2(-acc2norm(:,1),sqrt(acc2norm(:,3).^2 + acc2norm(:,2).^2))*180/pi;
PelQuatHigh2 = angle2quatInverted(LFX_angle2*pi/180,FX_angle2*pi/180,zeros(1,length(FX_angle2)),'xyz');
gyro2reorder = 0.5*[gyro2(:,3),gyro2(:,1),gyro2(:,2)];
TibiaQuatHighEKF = AttitudeQuatKalmanFilter(gyro2reorder,PelQuatHigh2,time,0.5,0.3,0.08,0.01,1);
rotm = [cos(45*pi/180) -sin(45*pi/180) 0;sin(45*pi/180) cos(45*pi/180) 0;0 0 1];
SensorQuatRot = rotm2quat(rotm);
TibiaQuatHighEKFRot = quatmult(SensorQuatRot,TibiaQuatHighEKF)';
calQuatTemp2 = mean(TibiaQuatHighEKFRot(CalRange,1:4));
quatCal2 = quatmult((TibiaQuatHighEKFRot(:,1:4)),quatconj(calQuatTemp2))';
[roll2,~,~] = quat2angle2Inverted(quatCal2,'xyz');
% FX
FX_angle2 = atan2(acc2norm(:,3),acc2norm(:,2))*180/pi;
LFX_angle2 = atan2(-acc2norm(:,1),sqrt(acc2norm(:,3).^2 + acc2norm(:,2).^2))*180/pi;
PelQuatHigh2 = angle2quatInverted(LFX_angle2*pi/180,FX_angle2*pi/180,zeros(1,length(FX_angle2)),'xyz');
gyro2reorder = [gyro2(:,3),gyro2(:,1),gyro2(:,2)];
TibiaQuatHighEKF = AttitudeQuatKalmanFilter(gyro2reorder,PelQuatHigh2,time,0.5,0.005,0.005,0.01,1);
SensorQuatRot = rotm2quat(rotm);
TibiaQuatHighEKFRot = quatmult(SensorQuatRot,TibiaQuatHighEKF)';
calQuatTemp2 = mean(TibiaQuatHighEKFRot(CalRange,1:4));
quatCal2 = quatmult((TibiaQuatHighEKFRot(:,1:4)),quatconj(calQuatTemp2))';
[~,pitch2,~] = quat2angle2Inverted(quatCal2,'xyz');


% Dynamic Valgus Right
%LFX
acc3norm = normaliseAcc(acc3);
FX_angle3 = atan2(acc3norm(:,3),sqrt(acc3norm(:,2).^2 + acc3norm(:,1).^2))*180/pi;
LFX_angle3 = atan2(-acc3norm(:,1),sqrt(acc3norm(:,3).^2 + acc3norm(:,2).^2))*180/pi;
PelQuatHigh3 = angle2quatInverted(LFX_angle3*pi/180,FX_angle3*pi/180,zeros(1,length(FX_angle3)),'xyz');
gyro3reorder = 0.5*[gyro3(:,3),gyro3(:,1),gyro3(:,2)];
TibiaRQuatHighEKF = AttitudeQuatKalmanFilter(gyro3reorder,PelQuatHigh3,time,0.5,0.3,0.08,0.01,1);
rotmR = [cos(-45*pi/180) -sin(-45*pi/180) 0;sin(-45*pi/180) cos(-45*pi/180) 0;0 0 1];
SensorQuatRotR = rotm2quat(rotmR);
TibiaRQuatHighEKFRot = quatmult(SensorQuatRotR,TibiaRQuatHighEKF)';
calQuatTemp3 = mean(TibiaRQuatHighEKFRot(CalRange,1:4));
quatCal3 = quatmult((TibiaRQuatHighEKFRot(:,1:4)),quatconj(calQuatTemp3))';
[roll3,~,~] = quat2angle2Inverted(quatCal3,'xyz');
% FX
FX_angle3 = atan2(acc3norm(:,3),acc3norm(:,2))*180/pi;
LFX_angle3 = atan2(-acc3norm(:,1),sqrt(acc3norm(:,3).^2 + acc3norm(:,2).^2))*180/pi;
PelQuatHigh3 = angle2quatInverted(LFX_angle3*pi/180,FX_angle3*pi/180,zeros(1,length(FX_angle3)),'xyz');
gyro3reorder = [gyro3(:,3),gyro3(:,1),gyro3(:,2)];
TibiaRQuatHighEKF = AttitudeQuatKalmanFilter(gyro3reorder,PelQuatHigh3,time,0.5,0.005,0.005,0.01,1);
SensorQuatRotR = rotm2quat(rotmR);
TibiaRQuatHighEKFRot = quatmult(SensorQuatRotR,TibiaRQuatHighEKF)';
calQuatTemp3 = mean(TibiaRQuatHighEKFRot(CalRange,1:4));
quatCal3 = quatmult((TibiaRQuatHighEKFRot(:,1:4)),quatconj(calQuatTemp3))';
[~,pitch3,~] = quat2angle2Inverted(quatCal3,'xyz');

PEL_FX = roll'*180/pi;
PEL_LFX = pitch'*180/pi;
LSK_FX = pitch2'*180/pi;
LSK_LFX = roll2'*180/pi;
RSK_FX = pitch3'*180/pi;
RSK_LFX = roll3'*180/pi;

end