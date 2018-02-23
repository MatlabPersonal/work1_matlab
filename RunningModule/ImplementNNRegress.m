function [Output] = ImplementNNRegress(inputRange,outputRange,IW,LW,b1,b2,Input)
%---------------------------------------------------------------------------------------------
% [Output] = ImplementNNRegress(net,Input)
%
% applying trained neural network to fit input where:
%   -net: Matlab Neural Network Object
%   -Input: Testing Input that satisfies inputs requirements in net.inputs
% 
% based on NN tool box for Matlab 2017
% net trained with input and output procFcns 'mapminmax'
% activation Fcn Hyperbolic tangent sigmoid transfer function
%---------------------------------------------------------------------------------------------


% apply settings to input
N = size(Input,2);
l = size(Input,1);
x = zeros(l,N);
for i =1:l
    x(i,:) = applyMinMax(Input(i,:),inputRange(i,1),inputRange(i,2));
end

% Calculate Output forward propagate
y = b2+LW*tansig(b1*ones(1,N)+IW*x);

% unnormalise output
Output = reverseMinMax(y,outputRange(1),outputRange(2));

end