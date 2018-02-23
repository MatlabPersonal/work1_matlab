function [Name,LeftAccX,LeftAccY,LeftAccZ,LeftFE,LeftFIG,LeftGyroX,LeftGyroY,LeftGyroZ,LeftLF,LeftLIG,RightAccX,RightAccY,RightAccZ,RightFE,RightFIG,RightGyroX,RightGyroY,RightGyroZ,RightLF,RightLIG,Stc]=ReadCell(AllSubject,i,j)

    Name=AllSubject{i,j}{1,1};
    LeftAccX=AllSubject{i,j}{1,2};
    LeftAccY=AllSubject{i,j}{1,3};
    LeftAccZ=AllSubject{i,j}{1,4};
    LeftFE=AllSubject{i,j}{1,5};
    LeftFIG=AllSubject{i,j}{1,6};
    LeftGyroX=AllSubject{i,j}{1,7};
    LeftGyroY=AllSubject{i,j}{1,8};
    LeftGyroZ=AllSubject{i,j}{1,9};
    LeftLF=AllSubject{i,j}{1,10};
    LeftLIG=AllSubject{i,j}{1,11};
    RightAccX=AllSubject{i,j}{1,12};
    RightAccY=AllSubject{i,j}{1,13};
    RightAccZ=AllSubject{i,j}{1,14};
    RightFE=AllSubject{i,j}{1,15};
    RightFIG=AllSubject{i,j}{1,16};
    RightGyroX=AllSubject{i,j}{1,17};
    RightGyroY=AllSubject{i,j}{1,18};
    RightGyroZ=AllSubject{i,j}{1,19};
    RightLF=AllSubject{i,j}{1,20};
    RightLIG=AllSubject{i,j}{1,21};
    Stc=AllSubject{i,j}{1,22};
    
    %pre_treatment for sensor error (e.g. Delgado_Markey)
    if(~iscell(RightLIG))
    if(range(RightLIG)>=180)
        fprintf('Sensor Error on Right Leg\n');
        RightFIG=zeros(1,length(RightFIG));
        RightLIG=zeros(1,length(RightLIG));
    end
    end
    if(~iscell(LeftLIG))
    if(range(LeftLIG)>=180)
        fprintf('Sensor Error on Left Leg\n');
        LeftFIG=zeros(1,length(LeftFIG));
        LeftLIG=zeros(1,length(LeftLIG));
    end
    end    
    fprintf('You have read data for %s at cell location (%d,%d)\n',Name,i,j);
end