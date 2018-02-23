function [quat]=mag2quat(magx,magy,magz)
len = length(magx);
q0 = zeros(1,len);
q1 = zeros(1,len);
q2 = zeros(1,len);
q3 = zeros(1,len);

for i = 1:len
    tau=magx(i).^2+magy(i).^2;
    if magx(i)>=0
        q0(i) = sqrt(tau+magx(i).*sqrt(tau))./sqrt(2.*tau);
        q1(i) = zeros(length(magx(i)),1);
        q2(i) = zeros(length(magx(i)),1);
        q3(i) = magy(i)./(sqrt(2).*sqrt(tau+magx(i).*sqrt(tau)));
        
    else
        q0(i) = magy(i)./(sqrt(2).*sqrt(tau-magx(i).*sqrt(tau)));
        q1(i) = zeros(length(magx(i)),1);
        q2(i) = zeros(length(magx(i)),1);
        q3(i) = sqrt(tau-magx(i).*sqrt(tau))./sqrt(2.*tau);
    end
    
end
quat = [q0', q1', q2', q3'];
end