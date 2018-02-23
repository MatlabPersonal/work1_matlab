function [FX,LFX] = calculateDipAngle(acc)
%--------------------------------------------------------------------------
% acc in below order:
% x: vertical pointing down
% y: horizontal pointing right
% z: horizontal pointing out
% returns dip angles
%--------------------------------------------------------------------------
LFX = atan2(acc(:,3),-acc(:,1))*180/pi;
FX = atan2(-acc(:,2),sqrt(acc(:,3).^2 + acc(:,1).^2))*180/pi;
end