function [EulerX,gyroX,gyroY,gyroZ,angle_S]=decideLeadLeg(LeftFIG,RightFIG,RightGyroX,RightGyroY,RightGyroZ,RightLIG,LeftGyroX,LeftGyroY,LeftGyroZ,LeftLIG,j)

%DL box drop
if(j==1)
    if(mean(LeftFIG(1:ceil(length(LeftFIG)/2)))<mean(RightFIG(1:ceil(length(LeftFIG)/2)))) %if left leg lifted
        EulerX=RightFIG;
        gyroX=RightGyroX;
        gyroY=RightGyroY;
        gyroZ=RightGyroZ;
        angle_S=RightLIG;

    elseif(mean(LeftFIG(1:ceil(length(LeftFIG)/2)))>mean(RightFIG(1:ceil(length(LeftFIG)/2))))%if Right leg lifted
        EulerX=LeftFIG;
        gyroX=LeftGyroX;
        gyroY=LeftGyroY;
        gyroZ=LeftGyroZ;
        angle_S=LeftLIG;
    end
    
%SL box drop
elseif(j==2)
    if(iscell(RightFIG))
        EulerX=LeftFIG;
        gyroX=LeftGyroX;
        gyroY=LeftGyroY;
        gyroZ=LeftGyroZ;
        angle_S=LeftLIG;        
    elseif(iscell(LeftFIG))
        EulerX=RightFIG;
        gyroX=RightGyroX;
        gyroY=RightGyroY;
        gyroZ=RightGyroZ;
        angle_S=RightLIG;        
    end
end
end