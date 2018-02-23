%% InitPeakAcc
% Remove wrong peaks
% clear temp_left ; temp_left = InitPeakAcc_Left;
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
% InitPeakAcc_Left=temp_left;
% 
% %% Right
% clear temp_right; temp_right = InitPeakAcc_Right;
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
% InitPeakAcc_Right=temp_right;

%% Add peaks
clear temp_left ;temp_left = InitPeakAcc_Left;

% Left
cursors_left=[];
cursor_info_left = getCursorInfo(dcm_obj);  
for i=1:length(cursor_info_left)
    cursors_left(i) =  cursor_info_left(i).Position(1);
end
cursors_left=round(sort(cursors_left));
InitPeakAcc_Left = [InitPeakAcc_Left cursors_left];

%% Right
clear temp_right;temp_right = InitPeakAcc_Right;
cursors_right=[];
cursor_info_right = getCursorInfo(dcm_obj);
for i=1:length(cursor_info_right)
    cursors_right(i) =  cursor_info_right(i).Position(1);
end
cursors_right=round(sort(cursors_right));
InitPeakAcc_Right = [InitPeakAcc_Right cursors_right];