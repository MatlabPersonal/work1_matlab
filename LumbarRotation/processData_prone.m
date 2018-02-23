
function [EulerS1, EulerS2, EulerS3,...
          EulerLowerS1, EulerLowerS2, EulerLowerS3,...
          EulerUpperS1, EulerUpperS2, EulerUpperS3] = processData_prone(accX1,accY1,accZ1,accX2,accY2,accZ2,...
                                                   gyroX1,gyroY1,gyroZ1,gyroX2,gyroY2,gyroZ2,...
                                                   CalFx_low, CalLfx_low, CalFx_up, CalLfx_up)

CalFx_low = CalFx_low*pi/180;
CalLfx_low = CalLfx_low*pi/180;
CalFx_up = CalFx_up*pi/180;
CalLfx_up = CalLfx_up*pi/180;

qcal_upp =  angle2quat(CalFx_up,CalLfx_up,0,'xyz');
qcal_low =  angle2quat(CalFx_low,CalLfx_low,0,'xyz');

T=1/20;

if (length(accX1) < 5)
EulerS1 = 0;
EulerS2 = 0;
EulerS3 = 0;
EulerLowerS1 = 0;
EulerLowerS2 = 0;
EulerLowerS3 = 0;
EulerUpperS1 = 0;
EulerUpperS2 = 0;
EulerUpperS3 = 0;
    
else
    n_gyro_st=10;
    gyro_motion_threshold=10;
    % gyro baseline correction
    if(norm(gyroX1(1:n_gyro_st))+norm(gyroY1(1:n_gyro_st))+norm(gyroZ1(1:n_gyro_st))<gyro_motion_threshold)
    gyroX1=gyroX1-mean(gyroX1(1:n_gyro_st));
    gyroY1=gyroY1-mean(gyroY1(1:n_gyro_st));
    gyroZ1=gyroZ1-mean(gyroZ1(1:n_gyro_st));
    end
    if(norm(gyroX2(1:n_gyro_st))+norm(gyroY2(1:n_gyro_st))+norm(gyroZ2(1:n_gyro_st))<gyro_motion_threshold)
    gyroX2=gyroX2-mean(gyroX2(1:n_gyro_st));
    gyroY2=gyroY2-mean(gyroY2(1:n_gyro_st));
    gyroZ2=gyroZ2-mean(gyroZ2(1:n_gyro_st));
    end
acc1=[accX1',accY1',accZ1'];acc2=[accX2',accY2',accZ2'];
gyr1=[-gyroX1',gyroY1',-gyroZ1'];gyr2=[-gyroX2',gyroY2',-gyroZ2'];

mag_acc_low=sqrt(acc1(:,1).^2+acc1(:,2).^2+acc1(:,3).^2);
mag_acc_upp=sqrt(acc2(:,1).^2+acc2(:,2).^2+acc2(:,3).^2);

acc_fx1=atan2(-acc1(:,2),acc1(:,3)+eps);
% acc_lf1=asin(-acc1(:,1)./mag_acc_low);
acc_lf1=zeros(length(acc1),1);
acc_tx1=asin(acc1(:,1)./(mag_acc_low+eps));
q_vm1=quatint(angle2quat(mean(acc_fx1(1:5)),mean(acc_tx1(1:5)),mean(acc_lf1(1:5)),'xzy'),gyr1,T);
q_vm1_a=angle2quat(acc_fx1,acc_tx1,acc_lf1,'xzy');
acc_fx2=atan2(-acc2(:,2),-acc2(:,3)+eps);
% acc_lf2=asin(acc2(:,1)./mag_acc_upp);
acc_lf2=zeros(length(acc2),1);
acc_tx2=asin(-acc2(:,1)./(mag_acc_upp+eps));
q_vm2=quatint(angle2quat(-mean(acc_fx2(1:5)),-mean(acc_tx2(1:5)),mean(acc_lf2(1:5)),'xzy'),gyr2,T);
q_vm2_a=angle2quat(-acc_fx2,-acc_tx2,acc_lf2,'xzy');
q_rot=angle2quat(pi,0,pi,'xyz');
q_vm2=quatmult(quatconj(q_rot),quatmult(q_vm2,q_rot)')';
q_vm2_a=quatmult(quatconj(q_rot),quatmult(q_vm2_a,q_rot)')';
q_vm1_c=quatmult(q_vm1,quatconj(qcal_low))';
q_vm2_c=quatmult(q_vm2,quatconj(qcal_upp))';
q_vm1_ac=quatmult(q_vm1_a,quatconj(qcal_low))';
q_vm2_ac=quatmult(q_vm2_a,quatconj(qcal_upp))';
q_diff=quatmult(quatconj(q_vm1_c),q_vm2_c)';
q_diff_a=quatmult(quatconj(q_vm1_ac),q_vm2_ac)';
EulerS=quat2XZY(q_diff);
EulerAS=quat2XZY(q_diff_a);
EulerS(:,1:3)=linear_fix(EulerS(:,1:3),EulerAS(:,1:3),5);
% EulerS(:,1)=-EulerS(:,1);
% EulerS(:,3)=-EulerS(:,3);

EulerS1=EulerS(:,1)'/pi*180;
EulerS2=EulerS(:,2)'/pi*180;
EulerS3=EulerS(:,3)'/pi*180;

% Euler Lower
EulerLower = quat2XZY(q_vm1_c);
EulerLower_a = quat2XZY(q_vm1_ac);
EulerLower(:,1:3)=linear_fix(EulerLower(:,1:3),EulerLower_a(:,1:3),5);
% Euler Upper
EulerUpper = quat2XZY(q_vm2_c);
EulerUpper_a = quat2XZY(q_vm2_ac);
EulerUpper(:,1:3)=linear_fix(EulerUpper(:,1:3),EulerUpper_a(:,1:3),5);
%Outputting them
[B,A]=butter(2,2/(20/2),'low');
EulerLowerS1 = filtfilt(B,A,EulerLower(:,1)'/pi*180);
EulerLowerS2 = filtfilt(B,A,EulerLower(:,2)'/pi*180);
EulerLowerS3 = filtfilt(B,A,EulerLower(:,3)'/pi*180);

EulerUpperS1 = filtfilt(B,A,EulerUpper(:,1)'/pi*180);
EulerUpperS2 = filtfilt(B,A,EulerUpper(:,2)'/pi*180);
EulerUpperS3 = filtfilt(B,A,EulerUpper(:,3)'/pi*180);

end

