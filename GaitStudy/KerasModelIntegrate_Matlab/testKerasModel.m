%% load model and data
clear;
clc;
load('D:\Derek\Matlab\gait_study\algorithm\train\temp\export\adam_6_5_5_32_2017-12-21-11-41-28.mat');
load('D:\Derek\Matlab\gait_study\algorithm\data\SubFeatures_stage2.mat');
m = ExpandAllFeatures(SubFeatures);
ind = find(m(:,end)<400);
m(ind,:) = [];
[~,norm_info_all] = normaliseAllFeatures(m);
norm_info.min_val = norm_info_all.min_val([2 3 5 6 7]);
norm_info.max_val = norm_info_all.max_val([2 3 5 6 7]);
indices = [2 3 6 16 21];
ind_for_validate = [];
for i=1:length(indices)
    ind_for_validate = [ind_for_validate; find(m(:,1)==indices(i))];
end
ind_for_validate = sort(ind_for_validate);
test_data = m(ind_for_validate,[2 3 5 6]);
expected_results = m(ind_for_validate,7);

%% apply net

[test_results] = applyKerasTrainedModel(test_data,net,norm_info);
[error,error_max] = getPercentageError(test_results,expected_results,false);
figure;
plot(test_results,'bx'); hold on;
plot(expected_results,'r.');
ylim([0 3000]);
legend('test results','expected results');
title({'training results: Adam 5/5',['MAPE: ' num2str(error)]});
grid on;