function [vec] = mat2vec(in)
n = size(in,1);
m = size(in,2);
vec = zeros(2+n*m,1);
vec(1) = n;
vec(2) = m;
vec(3:end) = reshape(in,[],1);
end