function [EulerX,angle_S,typeMvt,gyroX,gyroY,gyroZ,tibia_angle,ms]=generate_input(seed)
t=1:seed;
EulerX=sin(t)';
angle_S=sin(t)';
typeMvt=3;
gyroX=sin(t);
gyroY=sin(t);
gyroZ=sin(t);
tibia_angle=45;
ms=sin(t);
end