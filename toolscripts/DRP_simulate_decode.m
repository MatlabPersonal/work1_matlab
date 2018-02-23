function DRP_simulate_decode(filename)
addpath('D:\Derek\Matlab\ProcessBinDLL');
addpath('D:\Derek\Matlab\EMGFilterDLL');
addpath('D:\Derek\Matlab\EKFProcessFileDLL\EKFprocessFileDLL');
[acc,gyro,mag,high_g_acc,high_speed_gyro,emg,...
    battery_voltage,battery_soc,acc_temp,mag_temp,...
    timeTZ,timeHighG,timeHsGyro,timeEmg] = qu_file_v6c(filename);
headers = {'Ts', 'Ax', 'Ay', 'Az', 'Gx', 'Gy', 'Gz', 'Mx', 'My', 'Mz', 'high-g Ts','high-g Ax', 'high-g Ay', 'high-g Az','soc','battery'};
m = [timeTZ' acc gyro];
if length(mag) == length(acc(:,1))
    m = [m mag];
else
    m = [m zeros(length(acc(:,1)),3)];
end
if length(high_g_acc(:,1)) == length(acc(:,1))
    m = [m timeTZ' high_g_acc];
else
    m = [m zeros(length(acc(:,1)),4)];
end
m = [m battery_soc' battery_voltage'];
filename_dec = [filename(1:end-4) '.decoded.csv'];
csvwrite_with_headers(filename_dec,m,headers);
if length(emg)>1
    [~,emg_filtered,~,timeEmg_ds] = DecodeAndFilterWrapper(filename);
    headers = {'Ts','emg'};
    m = [timeEmg_ds' emg_filtered'];
    filename_emg = [filename(1:end-4) '.emg.csv'];
    csvwrite_with_headers(filename_emg,m,headers);
end
gyro = double(gyro);
acc = double(acc);
timeTZ = double(timeTZ);
[q0,q1,q2,q3,roll,pitch,yaw] = runAttitudeEstimator(gyro(:,1)',gyro(:,2)',gyro(:,3)',acc(:,1)',acc(:,2)',acc(:,3)',0,0,0,timeTZ,2);
headers = {'Ts','q0','q1','q2','q3','roll','pitch','yaw'};
m = [timeTZ' q0' q1' q2' q3' roll' pitch' yaw'];
filename_atti = [filename(1:end-4) '.atti.csv'];
csvwrite_with_headers(filename_atti,m,headers);
end
