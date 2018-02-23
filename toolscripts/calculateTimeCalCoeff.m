function [coeff] = calculateTimeCalCoeff(num,den)
count = strfind(num,'f');
if(length(count)>4)
    num_d = hex2dec('ffffffff') - hex2dec(num)+1;
else
    num_d = hex2dec(num);
end
den_d = hex2dec(den);
coeff = num_d/den_d;
fprintf('delta t: %d ms, ref time: %d min\n',num_d,round(den_d/60000));
end