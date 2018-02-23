function [res] = detectLowSpeed(data,ind,delta)
th = 30; % cursor range threshold
len = length(data);
res = false;
if(ind-th<1)
    rangeStart = 1;
else
    rangeStart = ind - th;
end
if(ind+delta+th>len)
    rangeEnd = len;
else
    rangeEnd = ind + delta + th;
end
dataROI = data(rangeStart:rangeEnd);
value = max(dataROI) - min(dataROI);
if(value<1)
    res = true;
end

end