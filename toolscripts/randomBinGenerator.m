function randomBinGenerator(acc_freq,mag_freq,emg_freq,high_g_freq,hsGyro_freq,time_recorded,filename)

acc_freq = acc_freq + (round(acc_freq/5)*rand - round(acc_freq/10));
mag_freq = mag_freq + (round(mag_freq/5)*rand - round(mag_freq/10));
emg_freq = emg_freq + (round(emg_freq/5)*rand - round(emg_freq/10));
high_g_freq = high_g_freq + (round(high_g_freq/5)*rand - round(high_g_freq/10));
hsGyro_freq = hsGyro_freq + (round(hsGyro_freq/5)*rand - round(hsGyro_freq/10));
time_recorded = time_recorded + (round(time_recorded/5)*rand - round(time_recorded/10));

total_freq = acc_freq*2 + mag_freq + emg_freq/2 + high_g_freq + hsGyro_freq;
millisecs_each_page = round(1000*254/total_freq);
num_data_row = time_recorded*60*total_freq;
num_data_row = num_data_row - mod(num_data_row,254);
reshaped_data = zeros(num_data_row,8);
for i = 1:num_data_row
    seed = mod(i,254)/254;
    if  seed < acc_freq/total_freq %seed>=0 && seed<=acc_freq
        reshaped_data(i,1) = 1;
    elseif seed>acc_freq/total_freq && seed<=2*acc_freq/total_freq
        reshaped_data(i,1) = 2;
    elseif seed>2*acc_freq/total_freq && seed<=(2*acc_freq + mag_freq)/total_freq
        reshaped_data(i,1) = 3;
    elseif seed>(2*acc_freq + mag_freq)/total_freq && seed<=(2*acc_freq + mag_freq + emg_freq/2)/total_freq
        reshaped_data(i,1) = 5;
    elseif seed>(2*acc_freq + mag_freq + emg_freq/2)/total_freq && seed<=(2*acc_freq + mag_freq + emg_freq/2 + high_g_freq)/total_freq
        reshaped_data(i,1) = 4;
    else
        reshaped_data(i,1) = 7;
    end
end
reshaped_data(:,3:end) = rand(num_data_row,6)*255;
raw_data = reshape(reshaped_data',2032,num_data_row/254)';
len = size(raw_data,1);
time = (1:len)*millisecs_each_page - millisecs_each_page;
time_mat = zeros(len,4);
time_mat(:,4) = floor(time/2^24);
rem = mod(time,2^24);
time_mat(:,3) = floor(rem/2^16);
rem = mod(time,2^16);
time_mat(:,2) = floor(rem/2^8);
rem = mod(time,2^8);
time_mat(:,1) = rem;

crc = zeros(len,2);
head = rand(len,14)*255;
head(:,1) = 70;
head(:,2) = 76;
head(:,3:6) = time_mat;
counter1 = 1;
counter2 = 0;
for i = 1:len
    crc(i,1) = counter1;
    crc(i,2) = counter2;
    counter1 = counter1 + 1;
    if counter1 == 256
        counter1 = 0;
        counter2 = counter2 + 1;
        if counter2 == 256
            counter2 = 0;
        end
    end
end

raw_mat = [head raw_data crc];
raw_array = reshape(raw_mat',1,[]);
FID = fopen(filename,'w');
fwrite(FID,raw_array);
fclose(FID);
end


