%function out=codegen_ZYX_to_Quaternion(Z,Y,X)

%% Removing the unnecessary data copy by combining the input at the entry 
%  point to the function
function out=ZYX_to_Quaternion(in)

% in=[Z Y X];
cosin=cos(in/2);
sinin=sin(in/2);
        out = [ cosin(:,1).*cosin(:,2).*cosin(:,3) + sinin(:,1).*sinin(:,2).*sinin(:,3), ...
            cosin(:,1).*cosin(:,2).*sinin(:,3) - sinin(:,1).*sinin(:,2).*cosin(:,3), ...
            cosin(:,1).*sinin(:,2).*cosin(:,3) + sinin(:,1).*cosin(:,2).*sinin(:,3), ...
            sinin(:,1).*cosin(:,2).*cosin(:,3) - cosin(:,1).*sinin(:,2).*sinin(:,3)];