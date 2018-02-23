function [s] = sigmoid(t)
s = 1./(1 + exp(-t));
end