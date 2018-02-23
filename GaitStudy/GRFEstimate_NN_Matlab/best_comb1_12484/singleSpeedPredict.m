%% Initialise
clear;
clc;
load('D:\Derek\Matlab\gait_study\algorithm\data\SubFeatures_stage2.mat');
data = ExpandAllFeatures(SubFeatures);
data(data(:,7)<400,:) = [];
testingSubs = [2 3 6 16 21];
testingIdcs = [];
for i = 1:length(testingSubs)
    testingIdcs = [testingIdcs; find(data(:,1)==testingSubs(i))];
end
testingIdcs = sort(testingIdcs);
TestingData = data(testingIdcs,:);
TestingData = [TestingData zeros(length(testingIdcs),1)];

for i = 1:length(testingIdcs)
    load(['D:\Derek\Matlab\gait_study\algorithm\train_Matlab\best_comb1_12484\best_comb_single_speed\' num2str(TestingData(i,3)) '.mat']);
    TestingData(i,8) = optim_net([TestingData(i,2) TestingData(i,5) TestingData(i,6)]');
end

figure;
plot(TestingData(:,7),'rx');hold on;
plot(TestingData(:,8),'gx');
grid on;
xlabel('samples');
ylabel('GRF estimated');
legend('expected value','regressor output');


%% Plot one speed
TestingDataCopy = TestingData;
Speed = 4;
TestingDataCopy(TestingDataCopy(:,3)~=Speed,:) = [];
figure;
plot(TestingDataCopy(:,7),'rx');hold on;
plot(TestingDataCopy(:,8),'gx');

%% get err per sub per speed
TestingDataWithErr = [TestingData zeros(length(testingIdcs),1)];
TestingDataWithErr(:,9) = 100*abs(TestingDataWithErr(:,7) - TestingDataWithErr(:,8))./(max(TestingDataWithErr(:,7:8)')');
Speeds = [2 4 6 9 12 15];
err_mat = zeros(6,5);
for i = 1:length(TestingDataWithErr(:,1))
    col = find(testingSubs == TestingDataWithErr(i,1));
    row = find(Speeds == TestingDataWithErr(i,3));
    err_mat(row,col) = TestingDataWithErr(i,9);
end
