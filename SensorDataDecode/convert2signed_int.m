function [out]  = convert2signed_int(in)
% This function converts unsigned 16bit integer value in Little Endian
% format ,to signed 16 bit integer in Big Endian Format
in = double(in);
temp = [(in(:,3)+in(:,4)*256) (in(:,5)+in(:,6)*256) (in(:,7)+in(:,8)*256)];
isNegative = int16(bitget(temp,16));
out = single(int16(bitset(temp,16,0)) + (-32768)*isNegative);
end