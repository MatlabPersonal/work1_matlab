function quat_y =quatconj(quat_x) %#codegen

%% DN: Must fully define quat_y before assigning
quat_y = zeros(size(quat_x,1),4);

quat_y(:,1) = quat_x(:,1);
quat_y(:,2) = -quat_x(:,2);
quat_y(:,3) = -quat_x(:,3);
quat_y(:,4) = -quat_x(:,4);

end