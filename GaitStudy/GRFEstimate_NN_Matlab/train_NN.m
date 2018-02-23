%% Initialise
clear;
clc;
load('D:\Derek\Matlab\gait_study\algorithm\data\SubFeatures_stage2.mat');
data = ExpandAllFeatures(SubFeatures);
data(data(:,7)<400,:) = [];
%% Process Training Features and Outputs exclude Weight

testingSubs = [4 5 6 11 21];
testingIdcs = [];
for i = 1:length(testingSubs)
    testingIdcs = [testingIdcs; find(data(:,1)==testingSubs(i))];
end
testingIdcs = sort(testingIdcs);
trainingIdcs = setdiff(1:length(data(:,1)),testingIdcs);
TrainingInput = data(trainingIdcs,[2 3 5 6]);
TrainingOutput = data(trainingIdcs,7);
TestingInput = data(testingIdcs,[2 3 5 6]);
ExpectedOutput = data(testingIdcs,7);
%% Configure Neural Network
HiddenNeuronSize = [4];
algorithms = {'trainlm','trainbr','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd'};
algoInd = 2;
net = feedforwardnet(HiddenNeuronSize,algorithms{algoInd}); 
net = configure(net,TrainingInput',TrainingOutput');
net = init(net);

%% Train and Validate Neural Network Model
% in train function, the input/output is configured as row vectors,
% while they are saved as column vectors, hence calculate transpose
tic;
[net, tr] = train(net,TrainingInput',TrainingOutput');
toc;
%% Plot results figure
ValidateOutput = net(TrainingInput')';
rmse_regress = getRMSE(ValidateOutput,TrainingOutput);
[error_regress,error_regress_max] = getPercentageError(ValidateOutput,TrainingOutput,false);

figure;
plot(TrainingOutput);hold on;
plot(ValidateOutput,'r');
legend('Target GRF','Training output');
title({strcat('algorithm: ',algorithms{algoInd}),...
       strcat(num2str(HiddenNeuronSize),' neuron 1 hidden layer training results :'),...
       strcat('MAX % ERROR: ', num2str(error_regress_max)),...
       strcat('RMSE (in BW): ',num2str(rmse_regress)),...
       strcat('error (in %): ',num2str(error_regress))});
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

%% Inn GRF Order
tempmat = [ExpectedOutput TestingOutput];
tempmat = sortrows(tempmat,2);
tempmat1 = [TrainingOutput ValidateOutput];
tempmat1 = sortrows(tempmat1,2);
figure;
subplot(2,1,1);
plot(tempmat1(:,1),'rx');hold on;
plot(tempmat1(:,2),'linewidth',2);
legend('Target GRF','Trained output');
title({'NN regression training results', strcat('error (in %): ',num2str(error_regress))});
subplot(2,1,2);
plot(tempmat(:,1),'rx');hold on;
plot(tempmat(:,2),'linewidth',2);
legend('Target GRF','Tested output');
title({'Algo Output vs Expected Output',strcat('error (in %): ',num2str(error_testcase))});
   




