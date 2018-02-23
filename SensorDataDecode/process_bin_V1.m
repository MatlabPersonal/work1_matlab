%% ------------------------------------------------------------------------
% Process bin for V1 sensors entry function
% take a hex array input stream of a binary file from sensor and decode
% into readable arrays in engineering units.
%
% OUTPUTs:
% acc - accelerometer
% gyro - gyroscope
% mag - magnetometer
% high_g_interp - high g accelerometer
% battery - sensor power level
% time - time vector for each sensor
%
% INPUTs:
% raw_array: hex array directly read from binary file
% scale: scales for each sensor, pre-set by user
% ------------------------------------------------------------------------

function [accx,accy,accz,magx,magy,magz,gyrox,gyroy,gyroz,...
    high_g_interpx,high_g_interpy,high_g_interpz,...
    battery_soc,battery_voltage,timeInterp] = process_bin_V1(raw_array,acc_scale,high_g_scale,gyro_scale,mag_scale)

accx = zeros(1,1,'single');
accy = zeros(1,1,'single');
accz = zeros(1,1,'single');
gyrox = zeros(1,1,'single');
gyroy = zeros(1,1,'single');
gyroz = zeros(1,1,'single');
magx = zeros(1,1,'single');
magy = zeros(1,1,'single');
magz = zeros(1,1,'single');
high_g_interpx = zeros(1,1,'single');
high_g_interpy = zeros(1,1,'single');
high_g_interpz = zeros(1,1,'single');
battery_soc = zeros(1,1,'single');
battery_voltage= zeros(1,1,'single');
timeInterp = zeros(1,1,'single');

A = raw_array;
raw_data = reshape(A,[2048,length(A)/2048])';
cut_data = raw_data(raw_data(:,1)==70,:);
%Ignore the CLR bytes
data_end = size(cut_data,2)-2;
data_start=15;
%read content of each page
%|number of acc|number of gyro|number of mag|time stamp|number of high g|
nbr_of_pages = length(cut_data(:,1));
page_info = zeros(nbr_of_pages,5);
sensor_data = cut_data(:,data_start:data_end);
cut_data = double(cut_data);
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
        end
    end
end
page_info(:,4) = page_info(:,4) - page_info(1,4);
time = page_info(:,4);
num_time_corr = 0;
for i = 2:nbr_of_pages-1
    if(page_info(i,4) <= page_info(i-1,4))
        page_info(i,4) = fix(0.5*(page_info(i-1,4)+page_info(i+1,4)));
        num_time_corr = num_time_corr + 1;
    end
end

%reshape the data to a nx8 matrix so that the format is as follows:
%|sensor type|X axis|Y axis| Z axis|
%| 0    0    | 0 0  | 0 0  | 0 0   |
reshaped_data = zeros((data_end-data_start+1)*size(cut_data,1)/8,8);
for i= 1:size(cut_data,1)
    reshaped_data((i-1)*254+1:i*254,:) = reshape(cut_data(i,data_start:data_end),[8 254])';
end
acc = reshaped_data(mod(reshaped_data(:,1),16)==1,:);
gyro = reshaped_data(mod(reshaped_data(:,1),16)==2,:);
mag = reshaped_data(mod(reshaped_data(:,1),16)==3,:);
high_g_acc = reshaped_data(mod(reshaped_data(:,1),16)==4,:);
stc = fix((high_g_acc(:,2).*2.^8+ fix(high_g_acc(:,1)))./16);
%convert the uint8 to double so that interpolation can be done easily
cut_data = double(cut_data);
%max value is +-16g
acc = convert2signed_int(acc)*acc_scale/32768; % Natalie is +-4g
%max value is +-2000
gyro = convert2signed_int(gyro)*gyro_scale/32768; % Natalie is +-250deg/s
%max value is +-4912 uT = 49.12 Gauss
mag = convert2signed_int(mag)*mag_scale/32768; %0.0015
%max value is +-100g
high_g_acc = convert2signed_int(high_g_acc)*high_g_scale/32768;
gyro_raw=gyro;
high_g_acc_raw=high_g_acc;
battery_soc = cut_data(:,7)+cut_data(:,8)*256;
battery_voltage = (cut_data(:,9)+cut_data(:,10)*256)/1000;
interp_size = size(gyro_raw,1);
if interp_size < size(high_g_acc_raw,1)
    interp_size = size(high_g_acc_raw,1);
end
n = interp_size;
time=time-time(1);
timeInterp = linspace(time(1),time(end),n); % 8
timeStamp = [fix(page_info(2,4)/2); page_info(2:end,4)]; %compensate the first timeStamp
accTime = zeros(1,sum(page_info(:,1)));
accTimeIndexTemp = cumsum(page_info(:,1));
accTime(1:accTimeIndexTemp(1)) = 1:timeStamp(1)/page_info(1,1):timeStamp(1);
gyroTime = zeros(1,sum(page_info(:,2)));
gyroTimeIndexTemp = cumsum(page_info(:,2));
gyroTime(1:gyroTimeIndexTemp(1)) = 1:timeStamp(1)/page_info(1,2):timeStamp(1);
magTime = zeros(1,sum(page_info(:,3)));
magTimeIndexTemp = cumsum(page_info(:,3));
magTime(1:magTimeIndexTemp(1)) = 1:timeStamp(1)/page_info(1,3):timeStamp(1);
for i = 2:nbr_of_pages
    accTime(accTimeIndexTemp(i-1)+1:accTimeIndexTemp(i)) = timeStamp(i-1)+0.1:(timeStamp(i) - timeStamp(i-1))/page_info(i,1):timeStamp(i);
    gyroTime(gyroTimeIndexTemp(i-1)+1:gyroTimeIndexTemp(i)) = timeStamp(i-1)+0.1:(timeStamp(i) - timeStamp(i-1))/page_info(i,2):timeStamp(i);
    magTime(magTimeIndexTemp(i-1)+1:magTimeIndexTemp(i)) = timeStamp(i-1)+0.1:(timeStamp(i) - timeStamp(i-1))/page_info(i,3):timeStamp(i);
end
acc = interp1(accTime,acc,timeInterp);
gyro = interp1(gyroTime,gyro,timeInterp);
mag = interp1(magTime,mag,timeInterp);
acc(isnan(acc)) = 0;
gyro(isnan(gyro)) = 0;
mag(isnan(mag)) = 0;

% Interpolating other variables
battery_soc = interp1(1:size(battery_soc,1),double(battery_soc),linspace(1,size(battery_soc,1),n));
battery_voltage = interp1(1:size(battery_voltage,1),double(battery_voltage),linspace(1,size(battery_voltage,1),n));

% Interpolate High G acc

stctemp = stc;
if(length(stctemp~=0))
    indtemp = find(diff(stctemp)<0);
    if indtemp(1)<10
        indtemp = indtemp(2:end);
        stctemp(1) = 0;
    end
    timetemp = time;
    timetemp(1) = stc(indtemp(1));
    for i = 1:length(indtemp)-1
        stctemp(indtemp(i)+1:indtemp(i+1)) = stctemp(indtemp(i)+1:indtemp(i+1)) + timetemp(i);
    end
    stctemp(indtemp(length(indtemp))+1:end) = stctemp(indtemp(length(indtemp))+1:end) + timetemp(length(indtemp));
    indtemp2 = find(diff(stctemp)==0);
    for i = 1:length(indtemp2)-1
        stctemp(indtemp2(i)+1) = stctemp(indtemp2(i)+1) + 0.7;
    end
    stctemp(indtemp2(length(indtemp2))+1) = stctemp(indtemp2(length(indtemp2))+1) + 0.7;
    temp1 = find(diff(stctemp)<0);
    temp2 = find(diff(stctemp)==0);
    if(length(temp1) == 1 && isempty(temp2))
        ind = temp1+1;
        count = 1;
        while(stctemp(ind(1))<=stctemp(temp1(1)))
            stctemp(ind) = stctemp(temp1) + 0.01*count;
            count = count + 1;
            ind = ind +1;
        end
    end
    
    if(length(temp2) == 1 && isempty(temp1))
        ind = temp2+1;
        count = 1;
        while(stctemp(ind(1))==stctemp(temp2(1)))
            stctemp(ind) = stctemp(temp2) + 0.01*count;
            count = count + 1;
            ind = ind +1;
        end
    end
    stc2 = stctemp;
    temp_val = interp1(stc2, high_g_acc_raw, timeInterp);
    high_g_acc = temp_val(:,1:3);
    high_g_acc(isnan(high_g_acc)) = 0;
    offset=zeros(1,3);
    for i = 1:2
        offset(i) = mean(-high_g_acc(:,i))-mean(acc(:,i));
    end
    offset(3) = mean(high_g_acc(:,3))-mean(acc(:,3));
    
    high_g_acc(:,1) = -high_g_acc(:,1) - offset(1);
    high_g_acc(:,2) = -high_g_acc(:,2) - offset(2);
    high_g_acc(:,3) = high_g_acc(:,3) - offset(3);
end
accx = acc(:,1)';
accy = acc(:,2)';
accz = acc(:,3)';
gyrox = gyro(:,1)';
gyroy = gyro(:,2)';
gyroz = gyro(:,3)';
magx = mag(:,1)';
magy = mag(:,2)';
magz = mag(:,3)';
high_g_interpx = high_g_acc(:,1)';
high_g_interpy = high_g_acc(:,2)';
high_g_interpz = high_g_acc(:,3)';
end