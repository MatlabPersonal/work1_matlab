function [B,A] = mafilter(order)
B = 1/order*ones(order,1);
A = 1;
end