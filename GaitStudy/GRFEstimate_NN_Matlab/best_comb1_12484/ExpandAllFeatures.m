function [AllFeatures] = ExpandAllFeatures(SubFeatures)
len = length(SubFeatures);
bodyWeight = [];
Speed = [];
IPA_low = [];
IPA_high = [];
FF = [];
AP = [];
SubIndex = [];
for i = 1:size(SubFeatures,1)-1
    temp = str2double(SubFeatures{i+1,1}(5:6));
    if isnan(temp)
        temp = str2double(SubFeatures{i+1,1}(5));
    end
    SubFeatures{i+1,1} = temp;
end

for i = 2:len
    SubIndex = [SubIndex; SubFeatures{i,1}*ones(length(SubFeatures{i,5}),1)];
    bodyWeight = [bodyWeight; SubFeatures{i,2}*ones(length(SubFeatures{i,5}),1)];
    Speed = [Speed; SubFeatures{i,4}*ones(length(SubFeatures{i,5}),1)];
    IPA_low = [IPA_low; SubFeatures{i,5}];
    IPA_high = [IPA_high; SubFeatures{i,7}];
    FF = [FF; SubFeatures{i,17}];
    AP = [AP; SubFeatures{i,13}];
end
temp = [SubIndex bodyWeight Speed IPA_high IPA_low FF AP];

AllFeatures = temp;
end