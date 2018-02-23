%function out=codegen_XYZ_to_Quaternion(X,Y,Z)

%% Removing the unnecessary data copy by combining the input at the entry 
%  point to the function
function out=XYZ_to_Quaternion(in)

%in=[X Y Z];

cosin=cos(in/2);
sinin=sin(in/2);
        out = [ cosin(:,1).*cosin(:,2).*cosin(:,3) - sinin(:,1).*sinin(:,2).*sinin(:,3), ...
            cosin(:,1).*sinin(:,2).*sinin(:,3) + sinin(:,1).*cosin(:,2).*cosin(:,3), ...
            cosin(:,1).*sinin(:,2).*cosin(:,3) - sinin(:,1).*cosin(:,2).*sinin(:,3), ...
            cosin(:,1).*cosin(:,2).*sinin(:,3) + sinin(:,1).*sinin(:,2).*cosin(:,3)];