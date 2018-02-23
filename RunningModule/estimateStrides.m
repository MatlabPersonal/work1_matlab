function StrideNumber = estimateStrides(stSlope_Left,stSlope_Right)

temp = [length(stSlope_Left) length(stSlope_Right)];

[~,I]=max(temp);
StrideNumber = temp(I);

end