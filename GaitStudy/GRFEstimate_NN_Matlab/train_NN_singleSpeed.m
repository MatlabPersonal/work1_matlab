%% Initialise
clear;
clc;
load('D:\Derek\Matlab\gait_study\algorithm\data\SubFeatures_stage2.mat');
data = ExpandAllFeatures(SubFeatures);
data(data(:,7)<400,:) = [];
Speed = 6;
data(data(:,3)~=Speed,:) = [];
%% Process Training Features and Outputs exclude Weight

testingSubs = [2 3 6 16 21];
testingIdcs = [];
for i = 1:length(testingSubs)
    testingIdcs = [testingIdcs; find(data(:,1)==testingSubs(i))];
end
testingIdcs = sort(testingIdcs);
trainingIdcs = setdiff(1:length(data(:,1)),testingIdcs);
TrainingInput = data(trainingIdcs,[2 5 6]);
TrainingOutput = data(trainingIdcs,7);
TestingInput = data(testingIdcs,[2 5 6]);
ExpectedOutput = data(testingIdcs,7);
%% Configure Neural Network
HiddenNeuronSize = [3];
algorithms = {'trainlm','trainbr','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd'};
algoInd =2;
net = feedforwardnet(HiddenNeuronSize,algorithms{algoInd}); 
net = configure(net,TrainingInput',TrainingOutput');
net = init(net);

%% Train and Validate Neural Network Model
% in train function, the input/output is configured as row vectors,
% while they are saved as column vectors, hence calculate transpose
tic;
[net, tr] = train(net,TrainingInput',TrainingOutput');
toc;
%%
TestingOutput = net(TestingInput')';
TestingOutput(TestingOutput<0) = 0;
rmse_testcase = getRMSE(TestingOutput,ExpectedOutput);
[error_testcase,error_testcase_max] = getPercentageError(TestingOutput,ExpectedOutput,false);

figure;
plot(ExpectedOutput);hold on;
plot(TestingOutput,'r');
legend('Target LR','Trained output');
title({'NN Test data results:',...
       strcat('MAX % ERROR: ', num2str(error_testcase_max)),...
       strcat('RMSE (in BW): ',num2str(rmse_testcase)),...
       strcat('error (in %): ',num2str(error_testcase))});
   
%% apply optim
TestingOutput = optim_net(TestingInput')';
TestingOutput(TestingOutput<0) = 0;
rmse_testcase = getRMSE(TestingOutput,ExpectedOutput);
[error_testcase,error_testcase_max] = getPercentageError(TestingOutput,ExpectedOutput,false);

figure;
plot(ExpectedOutput);hold on;
plot(TestingOutput,'r');
legend('Target LR','Trained output');
title({'NN Test data results:',...
       strcat('MAX % ERROR: ', num2str(error_testcase_max)),...
       strcat('RMSE (in BW): ',num2str(rmse_testcase)),...
       strcat('error (in %): ',num2str(error_testcase))});





