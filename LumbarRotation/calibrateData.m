function [fx1, lf1, fx2, lf2] = calibrateData(accX1,accY1,accZ1,accX2,accY2,accZ2)

if (length(accX1) < 5)
    fx1 = 0;
    lf1 = 0;
    fx2 = 0;
    lf2 = 0;
else

acc1=[accX1',accY1',accZ1'];acc2=[accX2',accY2',accZ2'];
mag_acc_low=sqrt(acc1(:,1).^2+acc1(:,2).^2+acc1(:,3).^2);
mag_acc_upp=sqrt(acc2(:,1).^2+acc2(:,2).^2+acc2(:,3).^2);

fx1=mean(atan2(-acc1(:,2),acc1(:,3)))*180/pi;
lf1=mean(asin(-acc1(:,1)./mag_acc_low))*180/pi;
fx2=mean(atan2(-acc2(:,2),-acc2(:,3)))*180/pi;
lf2=mean(asin(acc2(:,1)./mag_acc_upp))*180/pi;

end