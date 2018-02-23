function [out] = forceMonotonicIncrease(in)
isfinished = false;
while(~isfinished)
    ind1 = find(diff(in) <= 0,1);
    if(isempty(ind1))
        isfinished = true;
    else
        in(ind1(1) + 1:end) = in(ind1(1) + 1:end) - in(ind1(1) + 1) + in(ind1(1)) + 0.001;
    end
end
out = in;
end