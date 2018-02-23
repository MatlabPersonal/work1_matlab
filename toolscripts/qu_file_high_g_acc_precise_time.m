function [acc,gyro,mag,high_g_acc,battery_soc,battery_voltage,time,timeIndex,timeInterp,stc] = qu_file_high_g_acc_precise_time(filename)
%
% for syncronising high g and low g data

m = memmapfile(filename);
A = m.Data;
raw_data = reshape(A,[2048,length(A)/2048])';

%remove the FF lines
% 70 is for checking the header, should add this to the end of page as
% well, to avoid data corruption in the middle.

cut_data = raw_data(raw_data(:,1)==70,:);
%%%Ignore the CLR bytes
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

% 1 - acc
% 2 - gyro
% 3 - mag
acc = reshaped_data(mod(reshaped_data(:,1),16)==1,:);
gyro = reshaped_data(mod(reshaped_data(:,1),16)==2,:);
mag = reshaped_data(mod(reshaped_data(:,1),16)==3,:);
high_g_acc = reshaped_data(mod(reshaped_data(:,1),16)==4,:);
stc = fix((high_g_acc(:,2).*2.^8+ fix(high_g_acc(:,1)))./16);

%convert the uint8 to double so that interpolation can be done easily
cut_data = double(cut_data);

%max value is +-16g
acc = convert2signed_int(acc)*16/32768; % Natalie is +-4g
%max value is +-2000
gyro = convert2signed_int(gyro)*2000/32768; % Natalie is +-250deg/s
%max value is +-4912 uT = 49.12 Gauss
mag = convert2signed_int(mag)*49.12/32768; %0.0015
%max value is +-100g
high_g_acc = convert2signed_int(high_g_acc)*100/32768;

acc_raw=acc;
gyro_raw=gyro;
mag_raw=mag;
high_g_acc_raw=high_g_acc;

%create variables of raw data, uncomment to enable:

assignin('base','acc_raw',acc_raw);
assignin('base','gyro_raw',gyro_raw);
assignin('base','mag_raw',mag_raw);
assignin('base','high_g_acc_raw',high_g_acc_raw);
assignin('base','acc',acc);
assignin('base','gyro',gyro);
assignin('base','mag',mag);
assignin('base','high_g_acc',high_g_acc);

battery_soc = cut_data(:,7)+cut_data(:,8)*256;
battery_voltage = (cut_data(:,9)+cut_data(:,10)*256)/1000;

%currently unused data:
%cpu_usage = cut_data(:,11)+cut_data(:,12)*256;
%ram_usage = cut_data(:,13)+cut_data(:,14)*256;

% calculate and display sampling frequency to validate data
rate_low = length(acc_raw(:,1))/(time(end) - time(1))*1000;
rate = length(high_g_acc_raw(:,1))/(time(end) - time(1))*1000;
rate_mag = length(mag_raw(:,1))/(time(end) - time(1))*1000;

fprintf('sampling rate of high g is %.2fHz, total time: %.2f secs\n',rate,(time(end) - time(1))/1000);
fprintf('sampling rate of TZ acc is %.2fHz, total time: %.2f secs\n',rate_low,(time(end) - time(1))/1000);
fprintf('sampling rate of TZ mag is %.2fHz, total time: %.2f secs\n',rate_mag,(time(end) - time(1))/1000);

% New: Interpolating acc/gyro/mag time
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
indtemp = find(diff(stctemp)<0); %indttemp should be smaller than time by 1.

% get rid of the first value
if indtemp(1)<10
%     fprintf('resolving bad value for first timestamp\n');
    indtemp = indtemp(2:end);
    stctemp(1) = 0;
end
%debug
if(length(indtemp)-length(time)~=-1)
    error('\nlength of timestamp mismatch! time stamps expected to be 1 sample larger\nresets: %d, time stamps: %d!\n',length(indtemp),length(time));
end

timetemp = time;
timetemp(1) = stc(indtemp(1));

for i = 1:length(indtemp)-1
    stctemp(indtemp(i)+1:indtemp(i+1)) = stctemp(indtemp(i)+1:indtemp(i+1)) + timetemp(i);
end
stctemp(indtemp(i+1)+1:end) = stctemp(indtemp(i+1)+1:end) + timetemp(i+1);
indtemp2 = find(diff(stctemp)==0);
for i = 1:length(indtemp2)-1
    stctemp(indtemp2(i)+1) = stctemp(indtemp2(i)+1) + 0.7;
end
stctemp(indtemp2(i+1)+1) = stctemp(indtemp2(i+1)+1) + 0.7;

%debug
temp1 = find(diff(stctemp)<0);
temp2 = find(diff(stctemp)==0);
if(length(temp1) == 1 && isempty(temp2))
    ind = temp1+1;
    count = 1;
    while(stctemp(ind)<=stctemp(temp1))
        stctemp(ind) = stctemp(temp1) + 0.01*count;
        count = count + 1;
        ind = ind +1;
    end
end

if(length(temp2) == 1 && isempty(temp1))
    ind = temp2+1;
    count = 1;
    while(stctemp(ind)==stctemp(temp2))
        stctemp(ind) = stctemp(temp2) + 0.01*count;
        count = count + 1;
        ind = ind +1;
    end
end

temp1 = find(diff(stctemp)<0);
temp2 = find(diff(stctemp)==0);

if(~isempty(temp1)||~isempty(temp2))
    error('cannot interpolate, non-increasing time stamp!\nnumber of negative differentials: %d\nnumber of zero differentials: %d\n',length(temp1),length(temp2));
end

stc2 = stctemp;
high_g_acc = interp1(stc2, high_g_acc_raw, timeInterp);
high_g_acc(isnan(high_g_acc)) = 0;
%Calibrate High g acc using low g acc
offset=zeros(1,3);
for i = 1:2
    offset(i) = mean(-high_g_acc(:,i))-mean(acc(:,i));
end
offset(3) = mean(high_g_acc(:,3))-mean(acc(:,3));

high_g_acc(:,1) = -high_g_acc(:,1) - offset(1);
high_g_acc(:,2) = -high_g_acc(:,2) - offset(2);
high_g_acc(:,3) = high_g_acc(:,3) - offset(3);

    function [out]  = convert2signed_int(in)
        % This function converts unsigned 16bit integer value in Little Endian
        % format ,to signed 16 bit integer in Big Endian Format
        temp = [(in(:,3)+in(:,4)*256) (in(:,5)+in(:,6)*256) (in(:,7)+in(:,8)*256)];
        isNegative = int16(bitget(temp,16));
        out = double(int16(bitset(temp,16,0)) + (-32768)*isNegative);
    end
end

