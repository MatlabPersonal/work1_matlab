function rmse = getRMSE(x,y)
% offset = mean(x) - mean(y);
temp=0;
for i=1:length(x)
    temp=(x(i)-y(i))^2+temp;
end
rmse = sqrt(temp/length(x));% - offset;
end