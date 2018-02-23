clear;
clc;
filename = 'D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\curtin_rev2\DVKW\mdm5079-2.bin'; % lower
addpath('D:\Derek\Matlab\ProcessBinDLL');
[acc1,gyro1,~,~,~,~,...
    ~,~,~,~,...
    timeTZ1,~,~,~] = qu_file_v6c(filename);
filename = 'D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\curtin_rev2\DVKW\mdm5083-2.bin'; % upper
[acc2,gyro2,~,~,~,~,...
    ~,~,~,~,...
    timeTZ2,~,~,~] = qu_file_v6c(filename);
figure;
subplot(211);
plot(acc1(:,1));
subplot(212);
plot(acc2(:,1));

%% - 
range1 = cursor_info(4).DataIndex:cursor_info(2).DataIndex;
range2 = cursor_info(3).DataIndex:cursor_info(1).DataIndex;
acc1_cut = acc1(range1,:);
gyro1_cut = gyro1(range1,:);
acc2_cut = acc2(range2,:);
gyro2_cut = gyro2(range2,:);
time_cut1 = timeTZ1(range1) - timeTZ1(range1(1));
time_cut = timeTZ2(range2) - timeTZ2(range2(1));
% acc1_interp = interp1(1:size(acc1_cut,1),acc1_cut,linspace(1,size(acc1_cut,1),size(acc2_cut,1)));
% gyro1_interp = interp1(1:size(gyro1_cut,1),gyro1_cut,linspace(1,size(gyro1_cut,1),size(gyro2_cut,1)));
acc1_interp = interp1(time_cut1,acc1_cut,time_cut);

gyro1_interp = interp1(time_cut1,gyro1_cut,time_cut);
figure;
a(1) = subplot(311);
plot(acc1_interp(:,1)); hold on;
plot(acc2_cut(:,1),'r');
title('acc x');
legend('0006','0014');
a(2) = subplot(312);
plot(acc1_interp(:,2));hold on;
plot(acc2_cut(:,2),'r');
title('acc y');
a(3) = subplot(313);
plot(acc1_interp(:,3));hold on;
plot(acc2_cut(:,3),'r');
title('acc z');
linkaxes(a,'x');

figure;
a(1) = subplot(311);
plot(gyro1_interp(:,1)); hold on;
plot(gyro2_cut(:,1),'r');
title('gyro x');
legend('0006','0014');
a(2) = subplot(312);
plot(gyro1_interp(:,2));hold on;
plot(gyro2_cut(:,2),'r');
title('gyro y');
a(3) = subplot(313);
plot(gyro1_interp(:,3));hold on;
plot(gyro2_cut(:,3),'r');
title('gyro z');
linkaxes(a,'x');
% corrcoefs = zeros(3,2);
% for i = 1:3
%     rmatacc = corrcoef(acc1_interp(:,i),acc2_cut(:,i));
%     rmatgyro = corrcoef(gyro1_interp(:,i),gyro2_cut(:,i));
%     corrcoefs(i,1) = rmatacc(2,1);
%     corrcoefs(i,2) = rmatgyro(2,1);
% end

%% - 


[q0,q1,q2,q3,~,~,~] = runAttitudeEstimator(...
    gyro1_interp(:,1)',gyro1_interp(:,2)',gyro1_interp(:,3)',...
    acc1_interp(:,1)',acc1_interp(:,2)',acc1_interp(:,3)',...
    0,0,0,time_cut,2);
q11 = [q0' q1' q2' q3'];
[q0,q1,q2,q3,~,~,~] = runAttitudeEstimator(...
    gyro2_cut(:,1)',gyro2_cut(:,2)',gyro2_cut(:,3)',...
    acc2_cut(:,1)',acc2_cut(:,2)',acc2_cut(:,3)',...
    0,0,0,time_cut,2);
q22 = [q0' q1' q2' q3'];

figure;
subplot(411);
plot(time_cut,q11(:,1));
hold on;
plot(time_cut,q22(:,1),'r');
subplot(412);
plot(time_cut,q11(:,2));
hold on;
plot(time_cut,q22(:,2),'r');
subplot(413);
plot(time_cut,q11(:,3));
hold on;
plot(time_cut,q22(:,3),'r');
subplot(414);
plot(time_cut,q11(:,4));
hold on;
plot(time_cut,q22(:,4),'r');

%% calibrate and plot
calRange = 159:169;
calQuat = mean(q11(calRange,:));
ql1Out = quatmult(q11,quatconj(calQuat))';
calQuat = mean(q22(calRange,:));
qs2Out = quatmult(q22,quatconj(calQuat))';
qj = quatmult(quatconj(ql1Out),qs2Out);
[r1,p1,y1] = quat2angle2Inverted(ql1Out,'zyx');
[r2,p2,y2] = quat2angle2Inverted(qs2Out,'zyx');
[r,p,y] = quat2angle2Inverted(qj','zyx');
figure;
subplot(311); hold on;
plot(r2*180/pi,'r');
plot(r1*180/pi);
subplot(312); hold on;
plot(p2*180/pi,'r');
plot(p1*180/pi);
subplot(313); hold on;
plot(y2*180/pi,'r');
plot(y1*180/pi);
% figure;
% subplot(311);
% plot(r2*180/pi);
% subplot(312);
% plot(p2*180/pi);
% subplot(313);
% plot(y2*180/pi);
figure;
subplot(311); hold on;
plot(-r*180/pi,'r');
subplot(312); hold on;
plot(-p*180/pi,'r');
subplot(313); hold on;
plot(y*180/pi,'r');
