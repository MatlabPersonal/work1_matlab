function [out1,out2]=vt(in1,in2,alfa)
alfa_rad=alfa/180*pi;
out1=in1*cos(alfa_rad)+in2*sin(alfa_rad);
out2=in1*sin(alfa_rad)-in2*cos(alfa_rad);