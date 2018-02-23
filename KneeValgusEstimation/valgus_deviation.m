
%positive tibia angle for left leg and negative for right leg, usually
%around 45 (in degrees)
% in_csv_loc is location of input csv file in format [Stc Ax Ay Az Gx Gy
% Gz] without headers and out_csv_loc is the location of the output csv
% file.
%function out_flag=codegen_valgus_deviation(in_csv_loc,tibia_angle,out_csv_loc)

function [EulerX,EulerY,EulerZ,angle_S] = valgus_deviation(Stc,accx,accy,accz,gyrox,gyroy,gyroz,tibia_angle)
%function valgus_deviation(Stc,accx,accy,accz,gyrox,gyroy,gyroz,tibia_angle)
Stc=Stc';
acc = [accx;accy;accz]'; gyro = [gyrox;gyroy;gyroz]';
gyro_threshold=100; %big threshold
% gyro_threshold=9;
for m=1:3
if(sqrt(mean(gyro(1:10,m).^2))<=gyro_threshold)
%         m
%     mean(gyro(1:10,m))
    gyro(:,m)=gyro(:,m)-mean(gyro(1:10,m));

end
end
acc_t = zeros(size(acc,1),3);acc_t(:,1)=acc(:,1);
[acc_t(:,2),acc_t(:,3)]=vt(acc(:,2),-acc(:,3),tibia_angle);
gyro_sub=[-gyro(:,3),-gyro(:,2),-gyro(:,1)];
%gyro_sub=[gyro(:,3),gyro(:,2),gyro(:,1)];
acc_cal=mean(acc(1:20,:));
mag=norm(acc_cal);
anglez=-atan2(-acc_cal(2),-acc_cal(1));
%angley=asin(-acc_cal(3)/mag);
angley=-asin(acc_cal(3)/mag);
anglex=0;
calibrationM=1;

%% DN: Slight mod to function to remove data copy
%q0=ZYX_to_Quaternion(anglez,angley,anglex);
q0=ZYX_to_Quaternion([anglez,angley,anglex]);

%% DN: Need to substite data due to different inputs in codegen function.
%  Also need to explicitly specify the dimension that we are running the
%  difference on (so that Coder can determine the output array size)
T=median(diff(Stc,1,1))/1000;
% q0=[1 0 0 0];
% Integratign the gyroscope data onto quaternions
tempq=quatint(q0,gyro_sub,T);
% tempq=quatint_stc(q0,gyro_sub,Stc'/1000);
tempq_tibia_cal=(quatmult(tempq,XYZ_to_Quaternion([0,0,pi/180*tibia_angle])))';
tempqCal=quatconj(mean(tempq_tibia_cal(calibrationM:calibrationM+20,:)));
tempq_Caled=(quatmult(tempqCal,tempq_tibia_cal))';
% adjust quaternions using accelerometer
tempq_adj=update_w_acc(tempq_Caled,[],acc_t);
% tempq_adj=update_w_acc2(tempq_Caled,[],acc_t);

% Get DCM, FPPA angle (angle_S) and Euler angles
dcm13_S = 2.*(tempq_adj(:,2).*tempq_adj(:,4) + tempq_adj(:,1).*tempq_adj(:,3));
dcm33_S = tempq_adj(:,1).^2 - tempq_adj(:,2).^2 - tempq_adj(:,3).^2 + tempq_adj(:,4).^2;
angle_S=-(atan2(dcm13_S,dcm33_S)/pi*180)';
EulerS=-quaternion_to_XYZ(tempq_adj)/pi*180;
EulerX = EulerS(:,1)';
EulerY = EulerS(:,2)';
EulerZ = EulerS(:,3)';

% This is to negate the right leg's valgus/varus angles if sensor on the
% right leg
if(tibia_angle<0)
    EulerY=-EulerY;
    angle_S=-angle_S;
end

%%
% Test integrated raw gyro with angle_S/EulerY
% figure;
% intGyro = [cumtrapz(Stc/1000,gyro_sub(:,1)) cumtrapz(Stc/1000,gyro_sub(:,2)) cumtrapz(Stc/1000,gyro_sub(:,3))];
% [X,Y,Z] = quat2angle(tempq_tibia_cal,'XYZ');intQuat = [X Y Z]*180/pi;
% a(1)=subplot(1,2,1);plot([EulerY' angle_S']);legend('LFX','FPPA'); grid;
% a(2)=subplot(1,2,2); plot([intGyro intQuat]); grid; hold on;legend('IntRawGyroX','IntRawGyroY','IntRawGyroZ','IntQuatX','IntQuatY','IntQuatZ');
% linkaxes(a,'x');
% title('Test');


