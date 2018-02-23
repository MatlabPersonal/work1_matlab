function [q0j,q1j,q2j,q3j,roll_j,pitch_j,yaw_j] = runJointAngleCalculator(q10,q11,q12,q13,q20,q21,q22,q23)
len = max([length(q10) length(q20)]);
roll_j = zeros(1,len);
pitch_j = zeros(1,len);
yaw_j = zeros(1,len);
q0j = zeros(1,len);
q1j = zeros(1,len);
q2j = zeros(1,len);
q3j = zeros(1,len);
q1 = [q10' q11' q12' q13'];
q2 = [q20' q21' q22' q23'];

q1_interp = interp1(1:size(q1,1),q1,linspace(1,size(q1,1),len));
q2_interp = interp1(1:size(q2,1),q2,linspace(1,size(q2,1),len));
qj = quatmult(quatconj(q1_interp),q2_interp);
[roll,pitch,yaw] = quat2angle2Inverted(qj','xyz');
roll_j = roll';
pitch_j = pitch';
yaw_j = yaw';
q0j = qj(1,:);
q1j = qj(2,:);
q2j = qj(3,:);
q3j = qj(4,:);
end