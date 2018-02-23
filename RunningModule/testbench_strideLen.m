%%
clear;
clc;
dir_stage1 = 'D:\Derek\Matlab\gait_study\Data\ExtractData\ProcessedData\Stage 1';
folders = dir(dir_stage1);
len = length(folders);
count = 0;
for i = 1:len
    if(strfind(folders(i).name,'Subject'))
        subjectFolder{count+1} = folders(i).name;
        count = count + 1;
    end
end
data_all = [];
for i = 1:count
    disp(i);
    SubjectInd = i;
    subDir = strcat('D:\Derek\Matlab\gait_study\Data\ExtractData\ProcessedData\Stage 1\',subjectFolder{i});
    VAR = strcat('data',subjectFolder{i}(8:end));
    SubData = load(strcat(subDir,'\data.mat'),VAR);
    SubData = SubData.(VAR);
    % for Left
    if (~isempty(SubData{2,4}) && ~isempty(SubData{2,2}) && size(SubData,2) == 50)
        if(~isempty(SubData{2,50}))
            left_acc = SubData{2,4};
            right_acc = SubData{2,2};
            cursors = SubData{2,15};
            cursors = sort(cursors);
            if length(cursors) == 12
                start = SubData{2,8}(end);
                disp('step 1');
                % 9
                [left_data,right_data,~,~,time] = synchroniseSensors(left_acc(:,2)',right_acc(:,2)',right_acc(:,2)',right_acc(:,2)',SubData{2,9},[start + cursors(4) start + cursors(5)],[start + cursors(4) start + cursors(5)]);
                [strideLength] = strideLenEstimateWrapper(time,left_data,right_data);
                VSL = SubData{2,50};
                for j = 1:size(VSL,2)
                    if strfind(VSL{2,j},'FF9')
                        VstrideLength = mean(VSL{1,j});
                        data_col = [SubjectInd 9 strideLength VstrideLength];
                        data_all = [data_all; data_col];
                    end
                end
                %12
                disp('step 2');
                [left_data,right_data,~,~,time] = synchroniseSensors(left_acc(:,2)',right_acc(:,2)',right_acc(:,2)',right_acc(:,2)',SubData{2,9},[start + cursors(5) start + cursors(6)],[start + cursors(5) start + cursors(6)]);
                [strideLength] = strideLenEstimateWrapper(time,left_data,right_data);
                VSL = SubData{2,50};
                for j = 1:size(VSL,2)
                    if strfind(VSL{2,j},'FF12')
                        VstrideLength = mean(VSL{1,j});
                        data_col = [SubjectInd 12 strideLength VstrideLength];
                        data_all = [data_all; data_col];
                    end
                end
                %15
                disp('step 3');
                [left_data,right_data,~,~,time] = synchroniseSensors(left_acc(:,2)',right_acc(:,2)',right_acc(:,2)',right_acc(:,2)',SubData{2,9},[start + cursors(6) start + cursors(7)],[start + cursors(6) start + cursors(7)]);
                [strideLength] = strideLenEstimateWrapper(time,left_data,right_data);
                VSL = SubData{2,50};
                for j = 1:size(VSL,2)
                    if strfind(VSL{2,j},'FF15')
                        VstrideLength = mean(VSL{1,j});
                        data_col = [SubjectInd 15 strideLength VstrideLength];
                        data_all = [data_all; data_col];
                    end
                end
            end
        end
    end
end



