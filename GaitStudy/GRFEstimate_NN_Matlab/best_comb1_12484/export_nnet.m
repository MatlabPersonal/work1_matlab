csv_cols = {};
for i = 1:length(net)
    csv_col = [];
    csv_col = [csv_col; mat2vec(net{1,i}.inputRange)];
    csv_col = [csv_col; mat2vec(net{1,i}.outputRange)];
    csv_col = [csv_col; mat2vec(net{1,i}.IW)];
    csv_col = [csv_col; mat2vec(net{1,i}.LW)];
    csv_col = [csv_col; mat2vec(net{1,i}.b1)];
    csv_col = [csv_col; mat2vec(net{1,i}.b2)];
    csv_cols{1,i} = csv_col;
end
n = max([length(csv_cols{1,1}) length(csv_cols{1,2}) length(csv_cols{1,3}) length(csv_cols{1,4}) length(csv_cols{1,5}) length(csv_cols{1,6})]);
csv_data = zeros(n,length(net));
for i = 1:length(net)
    csv_data(1:length(csv_cols{1,i}),i) = csv_cols{1,i};
end
filename = 'D:\Derek\Matlab\gait_study\algorithm\train_Matlab\best_comb1_12484\best_comb_single_speed\nets_exported.csv';
headers = {'net_2','net_4','net_6','net_9','net_12','net_15'};
csvwrite_with_headers(filename,csv_data,headers);