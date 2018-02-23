function [c,l,indx,s,time_s] = findPeaksTroughs(data,x,y,time)

tic
data = data(x:y);
roundinN=floor(length(data)/2^7)*2^7;
s=data(1:roundinN);
s=interp1((1:roundinN)*5,s,5:((roundinN+1)*5-1),'cubic');

time_s = time(x:y);
time_s=time_s(1:roundinN);
time_s=interp1((1:roundinN)*5,time_s,5:((roundinN+1)*5-1),'linear');

[B,A]=butter(2,100/250,'low');
[c,l]=swt(filtfilt(B,A,s),7,'db1');
indx=cell(1,7);
for i=1:7
    indx{i} = crossing(l(i,:));
end

toc

%%
% Use the crossing function with the same number of samples
% [c,l]=swt(filtfilt(B,A,data),7,'db1');
% indx=cell(1,7);
% for i=1:7
%     indx{i} = crossing(l(i,:));
% end
% figure;
% plot(data);hold on;
% plot(indx{1},data(indx{1}),'ko');




end