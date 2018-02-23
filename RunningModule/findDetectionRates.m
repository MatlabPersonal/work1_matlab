%%
% player = 'player4';
% gaitEventsMeasured = {FootStrike_Left',  InitPeakAcc_Left',FlatFoot_Left', ToeOff_Left', stSlope_Left',EdSlope_Left', FootStrike_Right', InitPeakAcc_Right', FlatFoot_Right', ToeOff_Right', stSlope_Right', EdSlope_Right'};
% save(strcat(player,'_run1_measured.mat'),'gaitEventsMeasured');

%% REMOVE WRONG PEAKS FROM ALL TYPES
cursors=[];
cursor_info = getCursorInfo(dcm_obj);
for i=1:length(cursor_info)
    cursors(i) = cursor_info(i).Position(1);
end
cursors=round(sort(cursors));

for i=1:length(cursors)
    temp = find(cursors(i)==ToeOff_Left); 
    if ~isempty(temp)
        ToeOff_Left(temp)=[];
    end
    temp = find(cursors(i)==ToeOff_Right);
    if ~isempty(temp)
        ToeOff_Right(temp)=[];
    end
    temp = find(cursors(i)==FootStrike_Left);
    if ~isempty(temp)
        FootStrike_Left(temp)=[];
    end
    temp = find(cursors(i)==FootStrike_Right);
    if ~isempty(temp)
        FootStrike_Right(temp)=[];
    end
    temp = find(cursors(i)==InitPeakAcc_Left);
    if ~isempty(temp)
        InitPeakAcc_Left(temp)=[];
    end
    temp = find(cursors(i)==InitPeakAcc_Right);
    if ~isempty(temp)
        InitPeakAcc_Right(temp)=[];
    end
    temp = find(cursors(i)==FlatFoot_Left);
    if ~isempty(temp)
        FlatFoot_Left(temp)=[];
    end
    temp = find(cursors(i)==FlatFoot_Right);
    if ~isempty(temp)
        FlatFoot_Right(temp)=[];
    end
end

%%
symbol = {'x','o','*','^','.','+'}; colour = {'r','g','b','c','k','m'};
fig = figure;dcm_obj = datacursormode(fig); set(dcm_obj,'DisplayStyle','datatip','SnapToDataVertex','off','Enable','on');
% gaitEventsTrue = {FootStrike_Left',  InitPeakAcc_Left',FlatFoot_Left', ToeOff_Left', stSlope_Left',EdSlope_Left', FootStrike_Right', InitPeakAcc_Right', FlatFoot_Right', ToeOff_Right', stSlope_Right', EdSlope_Right'};
a(1)=subplot(2,1,1);plot(dataPlayer(:,2)); hold on; for i=1:6 plot(gaitEventsTrue{i},dataPlayer(gaitEventsTrue{i},2),strcat(colour{i},symbol{i}),'linewidth',2); end; legend('RAW','FS','IPA','FF','TO','ST','END');
a(2)=subplot(2,1,2);plot(dataPlayer(:,3)); hold on; for i=7:12 plot(gaitEventsTrue{i},dataPlayer(gaitEventsTrue{i},3),strcat(colour{i-6},symbol{i-6}),'linewidth',2);end; linkaxes(a,'x');
%save(strcat(player,'_run3_true.mat'),'gaitEventsTrue');

%% TOE OFF
% % Remove wrong peaks
% clear temp_left ; temp_left = ToeOff_Left;
% 
% % Left
% cursors_left=[];
% cursor_info_left = getCursorInfo(dcm_obj);
% for i=1:length(cursor_info_left)
%     cursors_left(i) =  cursor_info_left(i).Position(1);
% end
% cursors_left=round(sort(cursors_left));
% 
% for i=1:length(cursors_left)
%     temp_left(find(cursors_left(i)==temp_left)) = [];
% end
% ToeOff_Left=temp_left;
% 
% %% Right
% clear temp_right; temp_right = ToeOff_Right;
% cursors_right=[];
% cursor_info_right = getCursorInfo(dcm_obj);
% for i=1:length(cursor_info_right)
%     cursors_right(i) =  cursor_info_right(i).Position(1);
% end
% cursors_right=round(sort(cursors_right));
% 
% for i=1:length(cursors_right)
%     temp_right(find(cursors_right(i)==temp_right)) = [];
% end
% ToeOff_Right=temp_right;

%% Add peaks
% clear temp_left ;temp_left = ToeOff_Left;
% 
% % Left
% cursors_left=[];
% cursor_info_left = getCursorInfo(dcm_obj);
% for i=1:length(cursor_info_left)
%     cursors_left(i) =  cursor_info_left(i).Position(1);
% end
% cursors_left=round(sort(cursors_left));
% ToeOff_Left = [ToeOff_Left cursors_left];
% 
% %% Right
% clear temp_right;temp_right = ToeOff_Right;
% cursors_right=[];
% cursor_info_right = getCursorInfo(dcm_obj);
% for i=1:length(cursor_info_right)
%     cursors_right(i) =  cursor_info_right(i).Position(1);
% end
% cursors_right=round(sort(cursors_right));
% ToeOff_Right = [ToeOff_Right cursors_right];

%%  Compare True with Measured
% Assumes 'gaitEvents' (true) variable is loaded - Load for all players

k=1;
index = 1:26; index([11 12])=[]; dataTeam = dataAll{6}; i=1; m=3; %
for p=index
    gaitEventsMeasured=playerTemp{p,1}.gaitEventsMeasured;
    gaitEventsTrue=playerTemp{p,2}.gaitEventsTrue;
    
    % Make sure that <-1 is not taken into account in the reference dataset
    dataPlayer = dataTeam{p,m};
    gaitEventsTrue{1}(dataPlayer(gaitEventsTrue{1},2)<-1)=[];
    gaitEventsTrue{9}(dataPlayer(gaitEventsTrue{9},3)<-1)=[];
    
    % Detection Rates
    for i=1:12
        % False Positives on All Detected (Accuracy)
        totalFalsePositives(p,i) = 100*length(setdiff(gaitEventsMeasured{i},gaitEventsTrue{i}))/length(gaitEventsTrue{i});        
        % False Negatives on True values (Recall)
        totalFalseNegatives(p,i) = 100*length(setdiff(gaitEventsTrue{i},gaitEventsMeasured{i}))/length(gaitEventsTrue{i});        
    end
    
end

totalError = mean([totalFalsePositives(:,1)' totalFalsePositives(:,9)']) + mean([totalFalseNegatives(:,1)' totalFalseNegatives(:,9)']);

%%
BodyMass=80; counter=1;k=1;
index = 1:26;
for p=index
    
    % Measured
    dataPlayer=playerTemp{p,1}.gaitEventsMeasured{13};
    dataStc = dataPlayer(:,1);
    
    dataFilt_Left = playerTemp{p,1}.gaitEventsMeasured{14};
    troughsSpeed_Left = playerTemp{p,1}.gaitEventsMeasured{15};
    dataFilt_Right = playerTemp{p,1}.gaitEventsMeasured{16};
    troughsSpeed_Right = playerTemp{p,1}.gaitEventsMeasured{17};
    
    % Variable Errors
    % Measured
    [GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
     GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
     ContactTime_Left, ContactTimeVector_Left,...
     ContactTime_Right, ContactTimeVector_Right,...
     Speed, SpeedVector,Distance, DistanceVector,...
     Cadence, CadenceVector, RunTime, StrideNumber,...
     ASI,ASI_Vector] = ...
        estimateMetrics(dataStc', BodyMass, dataPlayer(:,2)', gaitEventsMeasured{1}, gaitEventsMeasured{2}, gaitEventsMeasured{3}, gaitEventsMeasured{5}, gaitEventsMeasured{6}, gaitEventsMeasured{4},...
                                           dataPlayer(:,3)', gaitEventsMeasured{7}, gaitEventsMeasured{8}, gaitEventsMeasured{9}, gaitEventsMeasured{11}, gaitEventsMeasured{12}, gaitEventsMeasured{10},...
                                           dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right,...
                                           k,i,team,counter);

    measuredVariables = {GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
                         GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
                         ContactTime_Left, ContactTimeVector_Left,...
                         ContactTime_Right, ContactTimeVector_Right,...
                         Speed, SpeedVector,Distance, DistanceVector,...
                         Cadence, CadenceVector, RunTime, StrideNumber,...
                         ASI,ASI_Vector};                             

    % True
    [GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
     GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
     ContactTime_Left, ContactTimeVector_Left,...
     ContactTime_Right, ContactTimeVector_Right,...
     Speed, SpeedVector,Distance, DistanceVector,...
     Cadence, CadenceVector, RunTime, StrideNumber,...
     ASI,ASI_Vector] = ...
        estimateMetrics(dataStc', BodyMass, dataPlayer(:,2)', gaitEventsTrue{1}, gaitEventsTrue{2}, gaitEventsTrue{3}, gaitEventsTrue{5}, gaitEventsTrue{6}, gaitEventsTrue{4},...
                                           dataPlayer(:,3)', gaitEventsTrue{7}, gaitEventsTrue{8}, gaitEventsTrue{9}, gaitEventsTrue{11}, gaitEventsTrue{12}, gaitEventsTrue{10},...
                                           dataFilt_Left, troughsSpeed_Left, dataFilt_Right, troughsSpeed_Right,...
                                           k,i,team,counter);

    trueVariables = {GRF_Left, GRF_Vector_Left, IPA_Left, IPA_Vector_Left, ...
                         GRF_Right, GRF_Vector_Right, IPA_Right, IPA_Vector_Right, ...
                         ContactTime_Left, ContactTimeVector_Left,...
                         ContactTime_Right, ContactTimeVector_Right,...
                         Speed, SpeedVector,Distance, DistanceVector,...
                         Cadence, CadenceVector, RunTime, StrideNumber,...
                         ASI,ASI_Vector};                             

%     for i=1:22
%         errorVariable(k,i) = 100*(measuredVariables{i} - trueVariables{i})/trueVariables{i};
%     end

    k=k+1;
end

%%
m=1;FF=[];
for k=3
    gaitEventsTrue=playerTemp{k,2}.gaitEventsTrue;
    dataPlayer=playerTemp{k,1}.gaitEventsMeasured{13};
    dataStc = dataPlayer(:,1);
    if(~isempty(dataPlayer))
        %% Run Gait Event Detection Algorithm
        [events{k} detection{k}] = findRunningEvents_CWT(dataStc',dataPlayer(:,2)',dataPlayer(:,3)', ...
                                          gaitEventsTrue{1}, gaitEventsTrue{2}, sort(gaitEventsTrue{3}), gaitEventsTrue{5}, gaitEventsTrue{6}, gaitEventsTrue{4},...
                                          gaitEventsTrue{7}, gaitEventsTrue{8}, sort(gaitEventsTrue{9}), gaitEventsTrue{11}, gaitEventsTrue{12}, gaitEventsTrue{10}); % Left and Right);
                                                                                                                                                      
    end
    
end
%median(FF)
%%
detectionMat=[];
for k=index
    detectionMat = [detectionMat;cell2mat(detection(k))];
end
mean(detectionMat)
median(detectionMat)

%%
k=1;
[events{k} detection{k}] = findRunningEvents_CWT(dataAll{2}{1}(:,1)',dataAll{2}{1}(:,2)',dataAll{2}{1}(:,3)', ...
                                          1:10, 1:10, 1:10, 1:10, 1:10, 1:10,...
                                          1:10, 1:10, 1:10,1:10, 1:10, 1:10); % Left and Right);
                                      
                                      