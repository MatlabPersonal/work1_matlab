function [quat]=acc2quat(accx,accy,accz)
len = length(accx);
q0 = zeros(1,len);
q1 = zeros(1,len);
q2 = zeros(1,len);
q3 = zeros(1,len);
for i = 1:len
    if accz(i)>=0
        q0(i) = sqrt((accz(i)+1)./2);
        q1(i) = -accy(i)./sqrt(2.*(accz(i)+1));
        q2(i) = accx(i)./sqrt(2.*(1+accz(i)));
        q3(i) = 0;
    else
        q0(i) = -accy(i)./sqrt(2.*(1-accz(i)));
        q1(i) = sqrt((1-accz(i))./2);
        q2(i) = 0;
        q3(i) = accx(i)./sqrt(2.*(1-accz(i)));
    end
end
quat = [q0', q1', q2', q3'];
        
% FX_s6 = atan2(accz,sqrt(accy.^2 + accx.^2))*180/pi;
% LFX_s6 = atan2(accy,-accx)*180/pi;
% figure;
% plot([FX_s6 LFX_s6]);
% quat=angle2quatInverted(zeros(length(FX_s6*pi/180),1),-FX_s6*pi/180,LFX_s6*pi/180,'zyx');

end