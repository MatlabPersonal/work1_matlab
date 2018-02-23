%function speed = getSpeedsSquat(stc,projAngle,locsMaxDev)
function speed = getSpeedsSquat(locsMaxDev,gyro, tibia_angle)

gyro=gyro';
time = 1:locsMaxDev;
%deltaProjAngle = diff(projAngle(time));
%deltaStc = diff(stc(time))/1000;
gyroTA = zeros(length(gyro),3);
[gyroTA(:,3),gyroTA(:,2)]=vt(gyro(:,3),gyro(:,2),tibia_angle);
speedMedioLateral=gyroTA(:,2);

speedsMax = max(speedMedioLateral(time));
speedsMin = min(speedMedioLateral(time));

if abs(speedsMax) > abs(speedsMin) 
    speed = [speedsMax 1]; % Just to add in the second position 
else speed = [speedsMin 1]; % Just to add in the second position 
end

speed = abs(speed);
end