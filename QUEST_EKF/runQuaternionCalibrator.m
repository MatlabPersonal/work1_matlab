function [q0Out,q1Out,q2Out,q3Out,rollOut,pitchOut,yawOut] = runQuaternionCalibrator(q0,q1,q2,q3,calPoint)
% calibration of quaternions
len = length(q0);
q0Out = zeros(1,len);
q1Out = zeros(1,len);
q2Out = zeros(1,len);
q3Out = zeros(1,len);
rollOut = zeros(1,len); 
pitchOut = zeros(1,len);
yawOut = zeros(1,len);
if calPoint+10>len
    %in case user chose a point that is out of range
    calRange = 1:10;
else
    calRange = calPoint:calPoint+10;
end
qIn = [q0' q1' q2' q3'];
calQuat = mean(qIn(calRange,:));
qOut = quatmult(qIn,quatconj(calQuat))';

q0Out = qOut(:,1)';
q1Out = qOut(:,2)';
q2Out = qOut(:,3)';
q3Out = qOut(:,4)';
[r,p,y] = quat2angle2Inverted(qOut,'xyz');
rollOut = r'; 
pitchOut = p';
yawOut = y';
end
