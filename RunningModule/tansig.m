% activation function (Hyperbolic tangent sigmoid) - Derek
function [a] = tansig(n)
a = 2./(1+exp(-2*n))-1;
end