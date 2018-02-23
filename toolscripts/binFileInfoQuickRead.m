function [page_info,battery_voltage,battery_soc,time,raw_data] = binFileInfoQuickRead(filename)
% latest: emg counter is doubled for v6c firmware

m = memmapfile(filename);
A = m.Data;
raw_data = reshape(A,[2048,length(A)/2048])';

% remove the FF lines
% after this, the FF lines are replaced with linear interpolation of the
% page before and after

cut_data = raw_data(raw_data(:,1)==70,:);
% Ignore the CLR bytes
data_end = size(cut_data,2)-2;
data_start=15;
%read content of each page
%|number of acc|number of gyro|number of mag|time stamp|number of high g|
nbr_of_pages = length(cut_data(:,1));
page_info = zeros(nbr_of_pages,7);
sensor_data = cut_data(:,data_start:data_end);
cut_data = double(cut_data);
for i=1:nbr_of_pages
    page_info(i,4) = cut_data(i,3)+cut_data(i,4)*2^8+cut_data(i,5)*2^16+cut_data(i,6)*2^24;

    for j=1:254
        sensorType = mod(sensor_data(i,8*(j-1)+1),16);
        if sensorType == 1
            % TZ acc
            page_info(i,1) = page_info(i,1)+1;
        elseif sensorType == 3
            % mag
            page_info(i,3) = page_info(i,3)+1;
        elseif sensorType == 2
            % TZ gyro
            page_info(i,2) = page_info(i,2)+1;
        elseif sensorType == 4
            %high g acc
            page_info(i,5) = page_info(i,5)+1;
        elseif sensorType == 5
            %emg
            page_info(i,6) = page_info(i,6)+2;
        elseif sensorType == 7
            %high speed gyro
            page_info(i,7) = page_info(i,7)+1;
        end
    end
end
page_info(:,4) = page_info(:,4) - page_info(1,4);

% fix identical timestamps on two page, may be spi error, happens in
% mid/low power mode
num_time_corr = 0;
for i = 2:nbr_of_pages-1
    if(page_info(i,4) <= page_info(i-1,4))
        page_info(i,4) = fix(0.5*(page_info(i-1,4)+page_info(i+1,4)));
        num_time_corr = num_time_corr + 1;
    end
end
% assignin('base','raw_data',raw_data);
% assignin('base','page_info',page_info);

%reshape the data to a nx8 matrix so that the format is as follows:
%|sensor type|X axis|Y axis| Z axis|
%| 0    0    | 0 0  | 0 0  | 0 0   |
reshaped_data = zeros((data_end-data_start+1)*size(cut_data,1)/8,8); k=1;
for i= 1:size(cut_data,1)
    reshaped_data((i-1)*254+1:i*254,:) = reshape(cut_data(i,data_start:data_end),[8 254])';
    cut_data = double(cut_data);
    time(i) =  cut_data(i,3)+cut_data(i,4)*2^8+cut_data(i,5)*2^16+cut_data(i,6)*2^24;
    
    if(i~=1)
        if((time(i)-time(i-1))~=0)
            timeIndex(k) = i;
            k=k+1;
        end
    end
end

%convert the uint8 to double so that interpolation can be done easily
cut_data = double(cut_data);

battery_soc = cut_data(:,7)+cut_data(:,8)*256;
battery_voltage = (cut_data(:,9)+cut_data(:,10)*256)/1000;

rate_low = 1000/(median(diff(page_info(:,4)))/median(page_info(:,1)));
rate_mag = 1000/(median(diff(page_info(:,4)))/median(page_info(:,3)));
rate_high_g = 1000/(median(diff(page_info(:,4)))/median(page_info(:,5)));
rate_emg = 1000/(median(diff(page_info(:,4)))/median(page_info(:,6)));
rate_highSpeedGyro = 1000/(median(diff(page_info(:,4)))/median(page_info(:,7)));

estimated_end_time = median(diff(page_info(:,4)))*page_info(end,1)/median(page_info(:,1)) + page_info(end,4);

disp('-----------------------------------------------------------');
fprintf('decoding: %s\n',filename);
fprintf('recording start Voltage: %.2fV, soc: %d%%\n',battery_voltage(1),battery_soc(1));
fprintf('recording end Voltage: %.2fV, soc: %d%%\n',battery_voltage(end),battery_soc(end));
fprintf('estimated end time: %.2f secs (%.1fhours)\n',estimated_end_time/1000,estimated_end_time/3600000);
fprintf('\nsampling rate of TZ acc/gyro is %.2fHz\n',rate_low);
fprintf('\nsampling rate of TZ mag is %.2fHz\n',rate_mag);
fprintf('\nsampling rate of high g acc is %.2fHz\n',rate_high_g);
fprintf('\nsampling rate of ADC (emg) is %.2fHz\n',rate_emg);
fprintf('\nsampling rate of high speed gyro is %.2fHz\n',rate_highSpeedGyro);

th = median(diff(page_info(:,4))) * 1.5;
page_sample_med_acc = median(page_info(:,1));

num_corr = 0;
num_lost = 0;
for i = 1:nbr_of_pages-1
    current_page = nbr_of_pages - i;
    if(page_info(current_page,1) < page_sample_med_acc)
        %corrupted_page
        num_corr = num_corr + 1;
    end
    if(page_info(current_page + 1,4) - page_info(current_page,4)> th)
        %lost page
        num_lost = num_lost + 1;
    end
    
end

fprintf('\nnumber of corrupted pages: %d\n',num_corr);
fprintf('number of lost pages: %d\n',num_lost);
fprintf('number of corrupted timestamp: %d\n',num_time_corr);

disp(' ');
disp('end of file info reading');
disp('-----------------------------------------------------------');

end
