
function o=quat2XYZ(qin)
% [o(:,1),o(:,2),o(:,3)]=quat2angle(qin,'xyz');

qin = quatnormalize( qin );
o = zeros(size(qin,1),4);
[o(:,1),o(:,2),o(:,3)] = threeaxisrot( -2.*(qin(:,3).*qin(:,4) - qin(:,1).*qin(:,2)), ...
                                    qin(:,1).^2 - qin(:,2).^2 - qin(:,3).^2 + qin(:,4).^2, ...
                                    2.*(qin(:,2).*qin(:,4) + qin(:,1).*qin(:,3)), ...
                                   -2.*(qin(:,2).*qin(:,3) - qin(:,1).*qin(:,4)), ...
                                    qin(:,1).^2 + qin(:,2).^2 - qin(:,3).^2 - qin(:,4).^2);
