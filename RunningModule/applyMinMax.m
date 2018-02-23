function y = applyMinMax(x,min,max)
% Neural Network Process function 1 - Derek
y = 2*(x-min)/(max-min)-1;
end