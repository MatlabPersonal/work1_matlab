n = 10000;
for i=1:n   
    acc_scale=randi(100,1,1);
    gyro_scale=randi(10000,1,1);
    mag_scale=randi(100,1,1);
    high_g_scale=randi(1000,1,1);
    hsGyro_scale=randi(10000,1,1);
    L=randi(30000000,1,1);
    if(rem(i,2)==0)
        raw_array = zeros(1,L);
    else
        raw_array = rand(1,L);
        
    end
 
    tic
    % run process bin
    [accx,accy,accz,magx,magy,magz,gyrox,gyroy,gyroz,...
        high_g_interpx,high_g_interpy,high_g_interpz,...
        battery_soc,battery_voltage,timeTZOut,timeHighGOut,timeHsGyroOut,...
        emgOut,emgTimeOut,acc_tempOut,mag_tempOut,hsGyro_interpx,hsGyro_interpy,hsGyro_interpz] = process_bin(raw_array,acc_scale,high_g_scale,gyro_scale,mag_scale,hsGyro_scale);
    toc
end