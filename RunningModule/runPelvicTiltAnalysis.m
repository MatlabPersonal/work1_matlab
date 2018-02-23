function [FX,LFX] = runPelvicTiltAnalysis(acc,gyro,time,CalRange)
len = length(acc(:,1));
FX = zeros(1,len);
LFX = zeros(1,len);

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

for i = 1:len
    FX(i) = roll(i,1)*180/pi;
    LFX(i) = pitch(i,1)*180/pi;
end


end