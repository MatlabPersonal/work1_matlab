%% ------------------------------------------------------------------------
% Process bin entry function
% take a hex array input stream of a binary file from sensor and decode
% into readable arrays in engineering units.
%
% OUTPUTs:
% acc - accelerometer
% gyro - gyroscope
% mag - magnetometer
% high_g_interp - high g accelerometer
% hsGyro_interp - high speed gyroscope
% emg - electromyography sensor
% battery - sensor power level
% time - time vector for each sensor
% temp - temperature sensor
%
% INPUTs:
% raw_array: hex array directly read from binary file
% scale: scales for each sensor, pre-set by user
% ------------------------------------------------------------------------
clear;
clc;
filename = 'D:\Derek\Matlab\ProcessBinDLL\bugfiles\file.bin';
m = memmapfile(filename);
A = m.Data;
raw_array = A;
acc_scale = 4;
high_g_scale = 100;
gyro_scale = 250;
mag_scale = 49.12;
hsGyro_scale = 500;
%% preallocate for creating library
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
timeTZOut= zeros(1,1,'single');
timeHighGOut= zeros(1,1,'single');
timeHsGyroOut = zeros(1,1,'single');
emgOut = zeros(1,1,'single');
emgTimeOut = zeros(1,1,'single');
acc_tempOut = zeros(1,1,'single');
mag_tempOut = zeros(1,1,'single');
hsGyro_interpx = zeros(1,1,'single');
hsGyro_interpy = zeros(1,1,'single');
hsGyro_interpz = zeros(1,1,'single');
%decodeState = 0;
% reshape raw data into (# of pages) * (contents of each page)
A = raw_array';
if(mod(length(raw_array),2048)==0)
    %decodeState = 1;
    % if input array is valid
    raw_data = reshape(A,[2048,length(A)/2048])';
    %decodeState = 13;
    %% remove the corrupted pages
    % 70 is ascii 2 for F, all data pages should start with 'FL'
    raw_data(raw_data(:,1)~=70,:)=[];
    %decodeState = 14;
    % when whole page/latter part of data is corrupted, it results in CLR byte of the page to be 255
    raw_data = raw_data(raw_data(:,2048)~=255,:);
    %decodeState = 15;
    % sometimes when page is corrupted, all values is set to 0
    ind_corr2 = find(raw_data(:,2047)==0);
    %decodeState = 16;
    ind_corr3 = find(raw_data(:,2048)==0);
    %decodeState = 17;
    ind_corr4 = intersect(ind_corr2,ind_corr3);
    %decodeState = 18;
    raw_data(ind_corr4,:) = [];
    %decodeState = 19;
    % the CLR bytes should be monotonic increasing, remove inconsistent rows
    ind_corr5 = find(diff(raw_data(:,2048))<0);
    %decodeState = 20;
    raw_data(ind_corr5+1,:) = [];
    %decodeState = 21;
    if(length(raw_data(:,1)~=0))
        %decodeState = 2;
        % Ignore the CLR bytes from now on
        data_end = size(raw_data,2)-2;
        data_start=15;
        
        %% reshape the data to a nx8 matrix so that the format is as follows:
        % |sensor type|X axis|Y axis| Z axis|
        % | 0    0    | 0 0  | 0 0  | 0 0   |
        reshaped_data = zeros((data_end-data_start+1)*size(raw_data,1)/8,8);
        time = zeros(1,size(raw_data,1));
        
        % constructing page_info variable for sensor synchronisations, in below
        % format:
        % |acc|gyro|mag|time|high_g|emg|hsGyro|
        % flags for each sensor
        flag_TZ_acc = 1;
        flag_TZ_gyro = 2;
        flag_TZ_mag = 3;
        flag_highg = 4;
        flag_emg = 5;
        flag_hsGyro = 7;
        
        nbr_of_pages = length(raw_data(:,1));
        page_info = zeros(nbr_of_pages,7);
        sensor_data = raw_data(:,data_start:data_end);
        cut_data = single(raw_data);
        sensor_tags = sensor_data(:,1:8:end);
        tempVec = sensor_tags;
        tempVec(tempVec~=flag_TZ_acc) = 0;
        page_info(:,1) = sum(tempVec,2);
        tempVec = sensor_tags;
        tempVec(tempVec~=flag_TZ_gyro) = 0;
        page_info(:,2) = sum(tempVec,2)/2;
        tempVec = sensor_tags;
        tempVec(tempVec~=flag_TZ_mag) = 0;
        page_info(:,3) = sum(tempVec,2)/3;
        tempVec = sensor_tags;
        tempVec(mod(tempVec,2^4)~=flag_highg) = 0;
        tempVec(tempVec~=0) = flag_highg;
        % - NOTE: high g stc may be removed in future release.
        page_info(:,5) = sum(tempVec,2)/4;
        tempVec = sensor_tags;
        tempVec(tempVec~=flag_emg) = 0;
        page_info(:,6) = sum(tempVec,2)/2.5;
        tempVec = sensor_tags;
        tempVec(tempVec~=flag_hsGyro) = 0;
        page_info(:,7) = sum(tempVec,2)/7;
        % construct time vector and remove offset
        page_info(:,4) = cut_data(:,3)+cut_data(:,4)*2^8+cut_data(:,5)*2^16+cut_data(:,6)*2^24;
        page_info(:,4) = page_info(:,4) - page_info(1,4);
        %decodeState = 3;
        % fix corrupted timestamps
        num_time_corr = 0;
        for i = 2:nbr_of_pages-1
            if(page_info(i,4) <= page_info(i-1,4))
                page_info(i,4) = fix(0.5*(page_info(i-1,4)+page_info(i+1,4)));
                num_time_corr = num_time_corr + 1;
            end
        end
        
        % allocate reshaped data
        reshaped_data = reshape(sensor_data',8,size(sensor_data,1)*size(sensor_data,2)/8)';
        reshaped_data = single(reshaped_data);
        time = page_info(:,4)';
        
        % allocate raw variables
        acc = reshaped_data(mod(reshaped_data(:,1),16)==1,:);
        gyro = reshaped_data(mod(reshaped_data(:,1),16)==2,:);
        mag = reshaped_data(mod(reshaped_data(:,1),16)==3,:);
        high_g_acc = reshaped_data(mod(reshaped_data(:,1),16)==4,:);
        emg_raw = reshaped_data(mod(reshaped_data(:,1),16)==5,:);
        hsGyro_raw = reshaped_data(mod(reshaped_data(:,1),16)==7,:);
        
        % fix corrupted emg
        ind_emg = find(reshaped_data(:,1)==5);
        ind_emgLeftCor = intersect(intersect(find(reshaped_data(:,3)==255), find(reshaped_data(:,4)==255)), find(reshaped_data(:,5)==255));
        ind_emgRightCor = intersect(intersect(find(reshaped_data(:,6)==255), find(reshaped_data(:,7)==255)), find(reshaped_data(:,8)==255));
        ind_Cor = union(ind_emgLeftCor,ind_emgRightCor);
        ind_emgCor = intersect(ind_Cor,ind_emg);
        page_emgCor = floor(ind_emgCor/254);
%         page_emgCor = mod(ind_emgCor,256)+1;
        for i = 1:length(page_emgCor)
            page_info(page_emgCor(i),6) = page_info(page_emgCor(i),6) - 1;
        end
        emg = 1;
        %decodeState = 4;
        if(length(emg_raw>1))
            emg_temp = zeros(1,length(emg_raw(:,1))*2);
            emg_temp(1:2:end) = emg_raw(:,3) + emg_raw(:,4)*2^8 + emg_raw(:,5)*2^16;
            emg_temp(2:2:end) = emg_raw(:,6) + emg_raw(:,7)*2^8 + emg_raw(:,8)*2^16;
            emg_temp(emg_temp == 16777215) = [];
            emg = (emg_temp - 2^23)/4.1839e+06*1.6;
            emg = emg';
            rate_emg = length(emg)*1000/time(end);
        end
        
        % convert all raw variables to engineering unit
        acc = convert2signed_int(acc)*acc_scale/32768;
        gyro = convert2signed_int(gyro)*gyro_scale/32768;
        mag = convert2signed_int(mag)*mag_scale/32768;
        high_g_acc = convert2signed_int(high_g_acc)*high_g_scale/32768;
        hsGyro = convert2signed_int(hsGyro_raw)*hsGyro_scale/32768;
        battery_soc = cut_data(:,7)+cut_data(:,8)*256;
        battery_voltage = (cut_data(:,9)+cut_data(:,10)*256)/1000;
        acc_temp = cut_data(:,11)+cut_data(:,12)*256;
        mag_temp = cut_data(:,13)+cut_data(:,14)*256;
        acc_temp = acc_temp';
        mag_temp = mag_temp';
        
        %% interpolate and construct seperated time vector tp synchronise sensors
        %decodeState = 5;
        interp_size = length(acc(:,1));
        battery_soc = interp1(1:length(battery_soc),battery_soc,linspace(1,length(battery_soc),interp_size));
        battery_voltage = interp1(1:length(battery_voltage),battery_voltage,linspace(1,length(battery_voltage),interp_size));
        acc_tempOut = interp1(1:length(acc_temp),acc_temp,linspace(1,length(acc_temp),interp_size));
        mag_tempOut = interp1(1:length(mag_temp),mag_temp,linspace(1,length(mag_temp),interp_size));
        while(page_info(end,1) == 0)
            disp('?');
            gyro = gyro(1:end - page_info(end,2),:);
            mag = mag(1:end - page_info(end,3),:);
            emg = emg(1:end - page_info(end,6),:);
            high_g_acc = high_g_acc(1:end - page_info(end,5),:);
            hsGyro = hsGyro(1:end - page_info(end,7),:);
            page_info = page_info(1:end-1,:);
        end
        page_info_temp = page_info;
        
        [acc,~,~] = interpDataOverPage(acc,1,page_info_temp,interp_size);
        [gyro,~,timeTZ] = interpDataOverPage(gyro,2,page_info_temp,interp_size);
        acc(isnan(acc))=0;
        gyro(isnan(gyro))=0;
        timeTZOut = single(timeTZ);
        %decodeState = 6;
        if(length(mag)>1)
            [mag,~,~] = interpDataOverPage(mag,3,page_info_temp,interp_size);
            magx = mag(:,1)';
            magy = mag(:,2)';
            magz = mag(:,3)';
        end
        %decodeState = 7;
        if(length(emg)>1)
            interp_size = length(emg);
            [~,~,emgTime] = interpDataOverPage(emg,5,page_info_temp,interp_size);
            emg = emg';
            emgTimeOut = single(emgTime);
            emgOut = single(emg);
        end
        %decodeState = 8;
        if(length(high_g_acc)>1)
            interp_size = length(high_g_acc(:,1));
            [high_g_acc,~,timeHighG] = interpDataOverPage(high_g_acc,4,page_info_temp,interp_size);
            timeHighGOut = single(timeHighG);
            high_g_acc(isnan(high_g_acc)) = 0;
            offset=zeros(1,3);
            for i = 1:2
                offset(i) = mean(-high_g_acc(:,i))-mean(acc(:,i));
            end
            offset(3) = mean(high_g_acc(:,3))-mean(acc(:,3));
            high_g_interpx = (-high_g_acc(:,1) - offset(1))';
            high_g_interpy = (-high_g_acc(:,2) - offset(2))';
            high_g_interpz = (high_g_acc(:,3) - offset(3))';
        end
        %decodeState = 9;
        if(length(hsGyro)>1)
            interp_size = length(hsGyro(:,1));
            [hsGyro,~,timeHsGyro] = interpDataOverPage(hsGyro,7,page_info_temp,interp_size);
            timeHsGyroOut = single(timeHsGyro);
            offset=zeros(1,3);
            for i = 1:3
                offset(i) = mean(hsGyro(:,i))-mean(gyro(:,i));
            end
            hsGyro_interpx = (hsGyro(:,1) - offset(1))';
            hsGyro_interpy = (hsGyro(:,2) - offset(2))';
            hsGyro_interpz = (hsGyro(:,3) - offset(3))';
        end
        %decodeState = 10;
        accx = acc(:,1)';
        accy = acc(:,2)';
        accz = acc(:,3)';
        gyrox = gyro(:,1)';
        gyroy = gyro(:,2)';
        gyroz = gyro(:,3)';
    end
end


