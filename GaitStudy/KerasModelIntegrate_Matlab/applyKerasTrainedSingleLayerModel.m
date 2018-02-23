function [test_results] = applyKerasTrainedSingleLayerModel(test_data,net,norm_info)
%--------------------------------------------------------------------------
% [Output] = applyKerasTrainedModel(test_data,net)
%
% applying Keras trained neural network to fit input where:
%   -net: Keras Neural Network Object as numpy array (2 layers)
%   -Input: Testing Input
% 
% based on Keras with Tensorflow, python 3, all activation function uses
% sigmoid (copy sigmoid.m together with this file for use elsewhere)
%--------------------------------------------------------------------------
for i = 1:size(test_data,2)
    test_data(:,i) = (test_data(:,i) - norm_info.min_val(i))/norm_info.max_val(i);
end
N = size(test_data,1);
L1_weight = double(net{1,1}');
L1_bias = double(net{1,2}');
output_weight = double(net{1,3}');
output_bias = double(net{1,4});
test_results = sigmoid(output_weight*sigmoid(...
    L1_weight*(test_data')...
    + L1_bias*ones(1,N))...
    +output_bias);
test_results = test_results'*norm_info.max_val(end) + norm_info.min_val(end);
end