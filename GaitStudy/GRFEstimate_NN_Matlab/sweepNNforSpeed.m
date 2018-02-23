clear;
clc;

Speed = 4;
target_err = 4;
error_testcase = 999;
min_err = 999;
load('D:\Derek\Matlab\gait_study\algorithm\data\SubFeatures_stage2.mat');
data = ExpandAllFeatures(SubFeatures);
data(data(:,7)<400,:) = [];
data(data(:,3)~=Speed,:) = [];
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
algorithms = {'trainlm','trainbr','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd'};
counter = 0;
while(error_testcase>target_err)
    tic;
    algoInd =randi(12);
    HiddenNeuronSize = randi(5)+1;
    net = feedforwardnet(HiddenNeuronSize,algorithms{algoInd});
    net = configure(net,TrainingInput',TrainingOutput');
    net = init(net);
    [net, tr] = train(net,TrainingInput',TrainingOutput');
    TestingOutput = net(TestingInput')';
    TestingOutput(TestingOutput<0) = 0;
    [error_testcase,error_testcase_max] = getPercentageError(TestingOutput,ExpectedOutput,false);
    counter = counter + 1;
    if error_testcase<min_err
        min_err = error_testcase;
        optim_net = net;
    end
    fprintf("%dth training, error: %.2f/current best: %.2f\n algo_seed: %d, neuron_seed: %d\n", counter,error_testcase,min_err,algoInd,HiddenNeuronSize);
    toc;
end



