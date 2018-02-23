temp1=LeftFIG;
temp2=RightFIG;
temp3=RightLIG;
temp4=LeftLIG;
clearvars LeftFIG;
clearvars RightFIG;
clearvars LeftLIG;
clearvars RightLIG;
for i=1:length(temp1)
    LeftFIG(i)=str2double(temp1{i});
    RightFIG(i)=str2double(temp2{i});
    RightLIG(i)=str2double(temp3{i});
    LeftLIG(i)=str2double(temp4{i});
end
LeftFIG=LeftFIG';
RightFIG=RightFIG';
RightLIG=RightLIG';
LeftLIG=LeftLIG';