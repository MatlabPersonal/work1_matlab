function [Aout, Bout] = shiftCursor(A,B)
len = length(A); % ideally the shorter one
temp1 = A(fix(len*0.2):fix(len*0.8));
rangeEnd = length(B) - length(temp1) -1;

min_error =  10000;
temp2 = B(1:length(temp1));
for i = 1:rangeEnd
    err = mean(abs(temp1 - B(i:i+length(temp1)-1)));
    if(err<min_error)
        min_error = err;
        temp2 = B(i:i+length(temp1)-1);
    end
end
Aout = temp1;
Bout = temp2;

end