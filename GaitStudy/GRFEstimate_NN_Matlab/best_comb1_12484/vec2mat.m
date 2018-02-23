function [mat] = vec2mat(in)
n = in(1);
m = in(2);
data = in(3:end);
mat = reshape(data,n,m);
end