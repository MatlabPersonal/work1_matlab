load('D:\Derek\Matlab\gait_study\algorithm\runningEventsDetection\MatlabFiles\data\VU gait study\strideLen.mat');
data_comp = data_all;
data_all(:,5) = data_all(:,4)./data_all(:,3);
coeff = mean(data_all(:,5));
data_comp(:,3) = coeff*data_comp(:,3);
data_comp(:,5) = abs(data_comp(:,3) - data_comp(:,4));
mean9 = mean(data_comp(data_comp(:,2)==9,5));
mean12 = mean(data_comp(data_comp(:,2)==12,5));
mean15 = mean(data_comp(data_comp(:,2)==15,5));