function [Stc,data_left,data_right] = readDataFromVM2RawCsv(filename)
[data] = xlsread(filename);
acc1y = data(:,3:5);
acc2y = data(:,14:16);

len = min([length(acc1y(:,1)) length(acc2y(:,1))]);
data_left = acc1y(1:len,:);
data_right = acc2y(1:len,:);
Stc = linspace(1,len*10,len);
end