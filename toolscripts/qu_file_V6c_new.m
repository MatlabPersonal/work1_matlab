function [raw_data,acc,gyro,emg,hsGyro,high_g_acc,battery_soc,battery_voltage,time,timeIndex,timeInterp,acc_temp,mag_temp,page_info] = qu_file_V6c(filename)
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
assignin('base','A',A);
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
sensor_data = cut_data(:,data_start:data_end);
nbr_of_pages = length(cut_data(:,1));
page_info = zeros(nbr_of_pages,7);
for i=1:nbr_of_pages
    page_info(i,4) = cut_data(i,3)+cut_data(i,4)*2^8+cut_data(i,5)*2^16+cut_data(i,6)*2^24;
    for j=1:254
        sensorType = mod(sensor_data(i,8*(j-1)+1),16);
        if sensorType == 1
            page_info(i,1) = page_info(i,1)+1;
        elseif sensorType == 3
            page_info(i,3) = page_info(i,3)+1;
        elseif sensorType == 2
            page_info(i,2) = page_info(i,2)+1;
        elseif sensorType == 4
            page_info(i,5) = page_info(i,5)+1;
        elseif sensorType == 5
            page_info(i,6) = page_info(i,6)+1;
        elseif sensorType == 7
            page_info(i,7) = page_info(i,7)+1;
        end
    end
end
page_info(:,4) = page_info(:,4) - page_info(1,4);

reshaped_data = reshape(cut_data(:,data_start:data_end)',[8 (data_end-data_start+1)*size(cut_data,1)/8])';

% 1 - acc
% 2 - gyro
% 3 - mag
acc = reshaped_data(reshaped_data(:,1)==1,:);
gyro = reshaped_data(reshaped_data(:,1)==2,:);
mag = reshaped_data(reshaped_data(:,1)==3,:);
emg_raw = reshaped_data(reshaped_data(:,1)==5,:);
assignin('base','emg_raw',emg_raw);
hsGyro_raw = reshaped_data(reshaped_data(:,1)==7,:);
high_g_acc = reshaped_data(mod(reshaped_data(:,1),16)==4,:);

emg_temp = zeros(1,length(emg_raw(:,1))*2);
emg_temp(1:2:end) = emg_raw(:,3) + emg_raw(:,4)*2^8 + emg_raw(:,5)*2^16;
emg_temp(2:2:end) = emg_raw(:,6) + emg_raw(:,7)*2^8 + emg_raw(:,8)*2^16;
emg_temp(emg_temp == 16777215) = [];
emg = (emg_temp - 2^23)/4.1839e+06*1.6;
% emg_x = emg_raw(:,3);
% emg_y = emg_raw(:,6)*2^8 + emg_raw(:,5);
% emg = emg_x*2^16 + emg_y - 2^23;
% emg = emg/4.1839e+06*1.6;

%convert the uint8 to double so that interpolation can be done easily
cut_data = double(cut_data);

%max value is +-8g
acc = convert2signed_int(acc)*4/32768; % Natalie is +-4g
%max value is +-500
gyro = convert2signed_int(gyro)*250/32768; % Natalie is +-250deg/s
%max value is +-4912 uT = 49.12 Gauss
mag = convert2signed_int(mag)*49.12/32768; %0.0015
high_g_acc = convert2signed_int(high_g_acc)*100/32768;
hsGyro = convert2signed_int(hsGyro_raw)*500/32768;

% acc_raw=acc;
% gyro_raw=gyro;
% mag_raw=mag;

% assignin('base','acc_raw',acc_raw);
% assignin('base','gyro_raw',gyro_raw);
% assignin('base','mag_raw',mag_raw);
% assignin('base','hsGyro_raw',hsGyro_raw);
% assignin('base','gyro',gyro);
% assignin('base','mag',mag);
battery_soc = cut_data(:,7)+cut_data(:,8)*256;
battery_voltage = (cut_data(:,9)+cut_data(:,10)*256)/1000;
acc_temp = cut_data(:,11)+cut_data(:,12)*256;
mag_temp = cut_data(:,13)+cut_data(:,14)*256;

% Interpolating using gyro vector size (minimum)
n = size(gyro,1);% size of gryo data that the interpolation is going to be done according to
acc = interp1(1:size(acc,1),acc,linspace(1,size(acc,1),n)); % Review of -1????
%acc = interp1(1:size(acc,1),acc,1:(size(acc,1)-1)/n:size(acc,1)); % Review of -1????
%mag = interp1(1:size(mag,1),mag,1:(size(mag,1)-1)/n:size(mag,1));

if(~isempty(mag))
    mag = interp1(1:size(mag,1),mag,linspace(1,size(mag,1),n));
end



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

    function [out]  = convert2signed_int(in)
        % This function converts unsigned 16bit integer value in Little Endian
        % format ,to signed 16 bit integer in Big Endian Format
        temp = [(in(:,3)+in(:,4)*256) (in(:,5)+in(:,6)*256) (in(:,7)+in(:,8)*256)];
        isNegative = int16(bitget(temp,16));
        out = double(int16(bitset(temp,16,0)) + (-32768)*isNegative);
    end
end

