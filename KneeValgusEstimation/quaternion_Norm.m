function out=quaternion_Norm(in)%#codegen
% DN: No changes required
norm_q=sqrt(in(:,1).^2+in(:,2).^2+in(:,3).^2+in(:,4).^2);
out=in./(norm_q*ones(1,4));