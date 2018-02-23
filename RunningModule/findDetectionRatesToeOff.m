%% TOE OFF
% Remove wrong peaks
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
clear temp_left ;temp_left = ToeOff_Left;

% Left
cursors_left=[];
cursor_info_left = getCursorInfo(dcm_obj);
for i=1:length(cursor_info_left)
    cursors_left(i) =  cursor_info_left(i).Position(1);
end
cursors_left=round(sort(cursors_left));
ToeOff_Left = [ToeOff_Left cursors_left];

%% Right
clear temp_right;temp_right = ToeOff_Right;
cursors_right=[];
cursor_info_right = getCursorInfo(dcm_obj);
for i=1:length(cursor_info_right)
    cursors_right(i) =  cursor_info_right(i).Position(1);
end
cursors_right=round(sort(cursors_right));
ToeOff_Right = [ToeOff_Right cursors_right];