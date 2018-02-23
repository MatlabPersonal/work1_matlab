function quat_result_transposed = quatmult(quat_x,quat_y)

% a0=by(:,1);a1=by(:,2);a2=by(:,3);a3=by(:,4);
% b0=x(:,1);b1=x(:,2);b2=x(:,3);b3=x(:,4);
% 
% res = [a0.*b0-a1.*b1-a2.*b2 - a3.*b3,...
% a0.*b1 + a1.*b0 + a2.*b3 -  a3.*b2,...
% a0.*b2 -  a1.*b3 + a2.*b0 + a3.*b1,...
% a0.*b3 + a1.*b2 -   a2.*b1 + a3.*b0]';

if size(quat_x,1)>size(quat_y,1)
    quat_result = zeros(size(quat_x,1),4);
else
    quat_result = zeros(size(quat_y,1),4);
end

quat_result(:,1) = quat_x(:,1).*quat_y(:,1) - quat_x(:,2).*quat_y(:,2) - quat_x(:,3).*quat_y(:,3) - quat_x(:,4).*quat_y(:,4);
quat_result(:,2) = quat_x(:,1).*quat_y(:,2) + quat_x(:,2).*quat_y(:,1) + quat_x(:,3).*quat_y(:,4) - quat_x(:,4).*quat_y(:,3);
quat_result(:,3) = quat_x(:,1).*quat_y(:,3) - quat_x(:,2).*quat_y(:,4) + quat_x(:,3).*quat_y(:,1) + quat_x(:,4).*quat_y(:,2);
quat_result(:,4) = quat_x(:,1).*quat_y(:,4) + quat_x(:,2).*quat_y(:,3) - quat_x(:,3).*quat_y(:,2) + quat_x(:,4).*quat_y(:,1);

quat_result_transposed = quat_result';

end