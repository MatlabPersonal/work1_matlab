%% Initialise
clear;
clc;
load('D:\Derek\Matlab\gait_study\algorithm\data\SubFeatures_stage2.mat');
data = ExpandAllFeatures(SubFeatures);
data(data(:,7)<400,:) = [];
%% Process Training Features and Outputs exclude Weight
allCombNK = combnk([1:8 10:21],5);
err_vector = [allCombNK zeros(size(allCombNK,1),1)];
min_err = 100;
for loopIdx = 1:size(allCombNK,1)
    tic;
    fprintf("looping: %d/%d\n",loopIdx,size(allCombNK,1));
    testingSubs = allCombNK(loopIdx,:);
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
    HiddenNeuronSize = 4;
    algorithms = {'trainlm','trainbr','trainbfg','trainrp','trainscg','traincgb','traincgf','traincgp','trainoss','traingdx','traingdm','traingd'};
    algoInd = 2;
    net = feedforwardnet(HiddenNeuronSize,algorithms{algoInd});
    net = configure(net,TrainingInput',TrainingOutput');
    net = init(net);
    [net, tr] = train(net,TrainingInput',TrainingOutput');
    TestingOutput = net(TestingInput')';
    TestingOutput(TestingOutput<0) = 0;
    rmse_testcase = getRMSE(TestingOutput,ExpectedOutput);
    [error_testcase,error_testcase_max] = getPercentageError(TestingOutput,ExpectedOutput,false);
    err_vector(loopIdx,6) = error_testcase;
    if error_testcase<min_err
        min_err = error_testcase;
        optim_net = net;
    end
    toc;
end


   




