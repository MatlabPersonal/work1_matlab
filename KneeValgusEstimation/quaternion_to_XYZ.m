function out=quaternion_to_XYZ(in) %#codegen
input_norm=quaternion_Norm(in);
out = rotation_xyz( -2.*(input_norm(:,3).*input_norm(:,4) - input_norm(:,1).*input_norm(:,2)), ...
    input_norm(:,1).^2 - input_norm(:,2).^2 - input_norm(:,3).^2 + input_norm(:,4).^2, ...
    2.*(input_norm(:,2).*input_norm(:,4) + input_norm(:,1).*input_norm(:,3)), ...
    -2.*(input_norm(:,2).*input_norm(:,3) - input_norm(:,1).*input_norm(:,4)), ...
    input_norm(:,1).^2 + input_norm(:,2).^2 - input_norm(:,3).^2 - input_norm(:,4).^2);

function out2 = rotation_xyz(in1,in2,in3,in4,in5)
%% DN: Must define out before assigning
out2 = zeros(size(in1,1),3);

out2(:,1)=atan2(in1,in2);
out2(:,2)=asin(in3);
out2(:,3) = atan2( in4,in5 );
