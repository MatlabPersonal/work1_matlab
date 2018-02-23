calRange = 3775;
[q0,q1,q2,q3,roll,pitch,yaw] = runAttitudeEstimator(gyro9100Interp(:,1)',gyro9100Interp(:,2)',gyro9100Interp(:,3)',acc9100Interp(:,1)',acc9100Interp(:,2)',acc9100Interp(:,3)',0,0,0,timeInterpDA,0);
[q0,q1,q2,q3,rollOut,pitchOut,yawOut] = runQuaternionCalibrator(q0,q1,q2,q3,calRange);
[q10,q11,q12,q13,roll,pitch,yaw] = runAttitudeEstimator(gyroDA(:,1)',gyroDA(:,2)',gyroDA(:,3)',accDA(:,1)',accDA(:,2)',accDA(:,3)',0,0,0,timeInterpDA,0);
[q10,q11,q12,q13,rollOut,pitchOut,yawOut] = runQuaternionCalibrator(q10,q11,q12,q13,calRange);
[q0j,q1j,q2j,q3j,roll_j,pitch_j,yaw_j] = runJointAngleCalculator(q0,q1,q2,q3,q10,q11,q12,q13);

figure;
subplot(211);
plot(roll_j);
subplot(212);
plot(pitch_j);