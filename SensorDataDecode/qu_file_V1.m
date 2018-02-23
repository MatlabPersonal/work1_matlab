function [acc,gyro,mag,high_g_acc,...
    battery_voltage,battery_soc,...
    timeTZ] = qu_file_V1(filename)
% filename = 'D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL\data\alan\mdm0002-25.bin';
m = memmapfile(filename);
A = m.Data;

 [accx,accy,accz,magx,magy,magz,gyrox,gyroy,gyroz,...
    high_g_interpx,high_g_interpy,high_g_interpz,...
    battery_soc,battery_voltage,timeTZ] = process_bin_V1(A',16,100,250,49.12);

acc = [accx' accy' accz'];
gyro = [gyrox' gyroy' gyroz'];
mag = [magx' magy' magz'];
high_g_acc = [high_g_interpx' high_g_interpy' high_g_interpz'];

end