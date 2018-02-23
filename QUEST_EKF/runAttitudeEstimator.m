function [q0,q1,q2,q3,roll,pitch,yaw] = runAttitudeEstimator(gyrox,gyroy,gyroz,accx,accy,accz,magx,magy,magz,Time,algoFlag)
len = length(Time);
roll = zeros(1,len);
pitch = zeros(1,len);
yaw = zeros(1,len);
q0 = zeros(1,len);
q1 = zeros(1,len);
q2 = zeros(1,len);
q3 = zeros(1,len);
% algorithm flag 
% 0: dynamic
% 1: dynamic with mag
% 2: non-dynamic
% 3: non-dunamic with mag
% 4: auto-detect dynamic/non-dynamic
switch algoFlag
    case 0
        [q0,q1,q2,q3,roll,pitch,yaw]...
            = AttitudeQuatKalmanFilter(gyrox,gyroy,gyroz,accx,accy,accz,magx,magy,magz,Time,0.5,0.005,0.005,0.01,true);
    case 1
        if(length(accx)==length(magx))
            [q0,q1,q2,q3,roll,pitch,yaw]...
                = AttitudeQuatKalmanFilter(gyrox,gyroy,gyroz,accx,accy,accz,magx,magy,magz,Time,0.5,0.005,0.005,0.01,false);
        end
    case 2
        [q0,q1,q2,q3,roll,pitch,yaw]...
            = AttitudeQuatKalmanFilter(gyrox,gyroy,gyroz,accx,accy,accz,magx,magy,magz,Time,0.5,0.02,0.005,0.01,true);
    case 3
        if(length(accx)==length(magx))
            [q0,q1,q2,q3,roll,pitch,yaw]...
                = AttitudeQuatKalmanFilter(gyrox,gyroy,gyroz,accx,accy,accz,magx,magy,magz,Time,0.5,0.05,0.005,0.01,false);
        end
    otherwise
end