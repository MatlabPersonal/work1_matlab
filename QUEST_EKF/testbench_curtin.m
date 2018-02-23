clear;
clc;
load('D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\curtin_rev2\DVKW\data.mat');
figure;
a(1) = subplot(211);
plot(lower_quat(:,1));
a(2) = subplot(212);
plot(upper_quat(:,2));
linkaxes(a,'x');

%%
lower_quat_interp = interp1(1:size(lower_quat,1),lower_quat,linspace(1,size(lower_quat,1),size(upper_quat,1)));
[r1,p1,y1] = quat2angle2Inverted(lower_quat_interp,'xyz');
[r2,p2,y2] = quat2angle2Inverted(upper_quat,'xyz');
figure;
a(1) = subplot(311);
plot(r1); hold on; plot(r2,'r');
a(2) = subplot(312);
plot(p1); hold on; plot(p2,'r');
a(3) = subplot(313);
plot(y1); hold on; plot(y2,'r');
linkaxes(a,'x');


%%

calRange = 1651:1661;
calQuat = mean(upper_quat(calRange,:));
upper_quatOut = quatmult(upper_quat,quatconj(calQuat))';
calQuat = mean(lower_quat_interp(calRange,:));
qs2Out = quatmult(lower_quat_interp,quatconj(calQuat))';
qj = quatmult(quatconj(upper_quatOut),qs2Out);
[r,p,y] = quat2angle2Inverted(upper_quatOut,'xyz');

figure;
subplot(311);
plot(r*180/pi);
subplot(312);
plot(p*180/pi);
subplot(313);
plot(y*180/pi);

