function [indTO,stSlope,edSlope,indFSOut] = findTO(data,indFS)
indTemp = zeros(1,length(indFS));
indTO = zeros(1,length(indFS));
edSlope = zeros(1,length(indFS));
stSlope = zeros(1,length(indFS));
for i = 1:length(indFS)-1
    [~,indTemp(i)] = findPeakPrevious(data,indFS(i+1),false,30); %before: 10 20 30 30
    [edSlopePeak,edSlope(i)] = findPeakPrevious(data,indTemp(i),true,30);
    [stSlopePeak,stSlope(i)] = findPeakPrevious(data,edSlope(i),false,30);
    while(edSlopePeak - stSlopePeak<0.5 && edSlope(i) - stSlope(i)<=30) %continue if did not reach th or larger than window
        [stSlopePeak,stSlope(i)] = findPeakPrevious(data,stSlope(i),false,30);
    end
    [TOpeak,indTO(i)] = findPeakPrevious(data,stSlope(i),true,30);
    while(TOpeak - stSlopePeak<0.2 && stSlope(i) - indTO(i)<=30) %continue if did not reach th or larger than window
        [TOpeak,indTO(i)] = findPeakPrevious(data,indTO(i),true,30);
    end
end
indFSOut = indFS;
indFSOut(indTO==0) = 0;
edSlope(edSlope==0) = [];
stSlope(stSlope==0) = [];
indTO(indTO==0) = [];
% figure;
% plot(data); hold on;
% % plot(indTemp,data(indTemp),'ro'); hold on;
% plot(indFS,data(indFS),'go'); hold on;
% plot(indTO,data(indTO),'ro'); hold on;
% plot(stSlope,data(stSlope),'ro'); hold on;
% plot(edSlope,data(edSlope),'ro'); hold on;
end