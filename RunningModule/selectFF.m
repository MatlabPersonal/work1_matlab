function [output] = selectFF(in,data,I)
% choose the correct FF location, adjust th to achieve expected results
% current idea: seperate speed with lowest acc for tuning algo against
% walking speed
if(min(data)>-2) % 4km/h
    n = length(in);
    switch n
        case 1
            output = in;
        case 2
            th = 0.4;
            if(data(in(2))-min(data(in(1):in(2)))>th)
                output = in(2);
            else
                output = in(1);
            end
        otherwise
            output = in(1);
    end
else %higher
    output = in(I(1)); 
end


end