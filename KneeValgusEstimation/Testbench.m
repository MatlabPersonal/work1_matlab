% Testbench for knee control test - 17/02/2014
%acc = [accX accY accZ]; gyro = [gyroX gyroY gyroZ];

delta = 1258:1717;
StcV2 = Stc(delta)-Stc(delta(1));
accX = Ax1(delta);
accY = Ay1(delta);
accZ = Az1(delta);
gyroX = Gx1(delta);
gyroY = Gy1(delta);
gyroZ = Gz1(delta);

% accX = Ax2(delta);
% accY = Ay2(delta);
% accZ = Az2(delta);
% gyroX = Gx2(delta);
% gyroY = Gy2(delta);
% gyroZ = Gz2(delta);

% dlmwrite('ganso_hop_rep2.csv',[Stc(delta) accX accY accZ gyroX gyroY gyroZ],'precision',10);

%%
tibia_angle = 45;
[EulerX,EulerY,EulerZ,angle_S] = valgus_deviation(StcV2',accX',accY',accZ',gyroX',gyroY',gyroZ',tibia_angle);
%valgus_deviation(Stc',accX',accY',accZ',gyroX',gyroY',gyroZ',tibia_angle);
EulerS=[EulerX',EulerY',EulerZ'];
figure;
a(1)=subplot(1,2,1);
plot(EulerS);
a(2)=subplot(1,2,2);plot([angle_S' EulerY']);
linkaxes(a,'x');

