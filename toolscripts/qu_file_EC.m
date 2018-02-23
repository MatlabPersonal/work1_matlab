function [gyro,acc,mag,battery_soc,battery_voltage,time,timeIndex,timeInterp] = qu_file_EC(filename)
%
% qu_file - extracts the input data in .bin to readible format
% 
% Format:  qu_file(filename,save_format) 
% 
% Input:    filename - the path of the .bin file that is going to be
% processed
%           save_format - either .mat or .csv will be saved depending on
%           the choice
% 
% Output:   Saves either the .mat file or the .csv file
m = memmapfile(filename);
A = m.Data;
raw_data = reshape(A,[2048,length(A)/2048])';

%remove the FF lines
% 70 is for checking the header
cut_data = raw_data(raw_data(:,1)==70,:);
%%%Ignore the CLR bytes
data_end = size(cut_data,2)-2;
data_start=15;
%reshape the data to a nx8 matrix so that the format is as follows:
%|sensor type|X axis|Y axis| Z axis|
%| 0    0    | 0 0  | 0 0  | 0 0   |
reshaped_data = zeros((data_end-data_start+1)*size(cut_data,1)/8,8); k=1;
for i= 1:size(cut_data,1)
    reshaped_data((i-1)*254+1:i*254,:) = reshape(cut_data(i,data_start:data_end),[8 254])';
    cut_data = double(cut_data);
    %time(i) = ((cut_data(i,3)*24+cut_data(i,4))*60+cut_data(i,5))*60+cut_data(i,6);
    %if(i==1)
    %    time(i) =  420; %420ms added as initialization occurs - attempt to fix this
    %else time(i) =  cut_data(i,3)+cut_data(i,4)*2^8+cut_data(i,5)*2^16+cut_data(i,6)*2^24;
    time(i) =  cut_data(i,3)+cut_data(i,4)*2^8+cut_data(i,5)*2^16+cut_data(i,6)*2^24;
    %end
    
    if(i~=1)
        if((time(i)-time(i-1))~=0)            
            timeIndex(k) = i;
            k=k+1;
        end
    end
end
% reshaped_data = reshape(cut_data(:,data_start:data_end)',[8 (data_end-data_start+1)*size(cut_data,1)/8])';
% 1 - acc
% 2 - gyro
% 3 - mag
acc = reshaped_data(reshaped_data(:,1)==1,:);
gyro = reshaped_data(reshaped_data(:,1)==2,:);
mag = reshaped_data(reshaped_data(:,1)==3,:);

%convert the uint8 to double so that interpolation can be done easily
cut_data = double(cut_data);

%max value is +-8g
acc = convert2signed_int(acc)*4/32768; % Natalie is +-4g
%max value is +-500
gyro = convert2signed_int(gyro)*250/32768; % Natalie is +-250deg/s
%max value is +-4912 uT = 49.12 Gauss
mag = convert2signed_int(mag)*49.12/32768; %0.0015
acc_raw=acc;
gyro_raw=gyro;
mag_raw=mag;
assignin('base','acc_raw',acc_raw);
assignin('base','gyro_raw',gyro_raw);
assignin('base','mag_raw',mag_raw);
assignin('base','acc',acc);
assignin('base','gyro',gyro);
assignin('base','mag',mag);
assignin('base','time',time);
battery_soc = cut_data(:,7)+cut_data(:,8)*256;
battery_voltage = (cut_data(:,9)+cut_data(:,10)*256)/1000;
%cpu_usage = cut_data(:,11)+cut_data(:,12)*256;
%ram_usage = cut_data(:,13)+cut_data(:,14)*256;

% Interpolating using gyro vector size (minimum)
n = size(gyro,1);% size of gryo data that the interpolation is going to be done according to
acc = interp1(1:size(acc,1),acc,linspace(1,size(acc,1),n)); % Review of -1????
%acc = interp1(1:size(acc,1),acc,1:(size(acc,1)-1)/n:size(acc,1)); % Review of -1????
%mag = interp1(1:size(mag,1),mag,1:(size(mag,1)-1)/n:size(mag,1));
mag = interp1(1:size(mag,1),mag,linspace(1,size(mag,1),n));
%battery_soc = interp1(1:size(battery_soc,1),double(battery_soc),1:(size(battery_soc,1)-1)/n:size(battery_soc,1));
battery_soc = interp1(1:size(battery_soc,1),double(battery_soc),linspace(1,size(battery_soc,1),n));
%battery_voltage = interp1(1:size(battery_voltage,1),double(battery_voltage),1:(size(battery_voltage,1)-1)/n:size(battery_voltage,1));
battery_voltage = interp1(1:size(battery_voltage,1),double(battery_voltage),linspace(1,size(battery_voltage,1),n));
time=time-time(1);
%timeInterp = interp1(linspace(0,time(end),length(time)-1), time(2:end), linspace(0,time(end),n));
% timeInterp =time(1):(time(end)+mean(diff(time))-time(1)-1)/n:(time(end)+mean(diff(time)));
% timeInterp = linspace(time(1),time(end)-360,n); % 3 and 6
% timeInterp = linspace(time(1),time(end)-310,n); % 4
timeInterp = linspace(time(1),time(end),n); % 8


% Calibration of sensors
%[acc,gyro,mag] = sensor_calibration(acc,gyro,mag,sensor_number);

if 0
%cpu_usage = interp1(1:size(cpu_usage,1),double(cpu_usage),1:(size(cpu_usage,1)-1)/n:size(cpu_usage,1));
%ram_usage = interp1(1:size(ram_usage,1),double(ram_usage),1:(size(ram_usage,1)-1)/n:size(ram_usage,1));
%time =time(1):(time(end)+mean(diff(time))-time(1)-1)/n:(time(end)+mean(diff(time)));
time = time-time(1);
time =linspace(time(1),time(end),n);

%add an extra line of gyro so that the sizes of the matrices are similar
% gyro = [gyro;gyro(end,:)];

if (strcmp(save_format,'.csv'))
    %precision in the data p= 10 means 1st significant digit,p=100 means 2nd significant digit and etc..
    p=1000;
    combined_data = [round(time'*p)/p round(acc*p)/p round(gyro*p)/p round(mag*p)/p battery_voltage' battery_soc'];
    mex_WriteMatrix('Raw_Data.csv',combined_data,'%f',',','w+');
    %dlmwrite('Raw_data.csv',combined_data);%takes too long
elseif (strcmp(save_format,'.mat'))
    save('Raw_Data.mat','time', 'acc', 'gyro', 'mag', 'battery_voltage', 'battery_soc','timeOriginal');
end

end
    function [out]  = convert2signed_int(in)
        % This function converts unsigned 16bit integer value in Little Endian
        % format ,to signed 16 bit integer in Big Endian Format
        temp = [(in(:,3)+in(:,4)*256) (in(:,5)+in(:,6)*256) (in(:,7)+in(:,8)*256)];
        isNegative = int16(bitget(temp,16));
        out = double(int16(bitset(temp,16,0)) + (-32768)*isNegative);
    end
end

