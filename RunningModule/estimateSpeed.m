function [Speed, SpeedVector, integrationCue] = estimateSpeed(Stc, data_Left, data_Right, stSlope_Left, EdSlope_Left, stSlope_Right, EdSlope_Right)

% Calculate maximum speed per leg
backupStc=Stc;
L_Left=length(stSlope_Left);
slope_Left = zeros(1,L_Left);
for i=1:L_Left
    delta_Left = stSlope_Left(i):EdSlope_Left(i);
    temp = data_Left(delta_Left);
    tempStc = Stc(delta_Left);
    tempStc = tempStc - tempStc(1);
    %slope_Left(i) = max(diff(temp)./diff(tempStc));
    slope = (diff(temp)./diff(tempStc));
    slope(isinf(slope))=[];
    slope_Left(i)=max(slope);
    %if (isinf(max(slope)))
    %    [~, idx] = sort(slope,'descend');
    %    slope_Left(i) = slope(idx(2));
    %else slope_Left(i)=max(slope);
    %end
end

Stc=backupStc;
L_Right=length(stSlope_Right);
slope_Right = zeros(1,L_Right);
for i=1:L_Right
    delta_Right = stSlope_Right(i):EdSlope_Right(i);
    temp = data_Right(delta_Right);
    tempStc = Stc(delta_Right);
    tempStc = tempStc - tempStc(1);
    %slope_Right(i) = max(diff(temp)./diff(tempStc));
    slope = (diff(temp)./diff(tempStc));
    slope(isinf(slope))=[]; %<FIXME: Why do we have zero Stc and thus we get inf values?>
    slope_Right(i)=max(slope);
    %if (isinf(max(slope)))
    %    [~, idx] = sort(slope,'descend');
    %    slope_Right(i) = slope(idx(2));
    %else slope_Right(i)=max(slope);
    %end
end

%% Remove duplicates of the slopes %<FIXME: why do we need this - source error>
temp_i=zeros(1,length(stSlope_Right)-1);counter=1;
for i=1:length(stSlope_Right)-1
    if stSlope_Right(i)==stSlope_Right(i+1)
    temp_i(counter)=i+1;counter=counter+1;
    end
end
temp_i=temp_i(1:counter-1);
stSlope_Right(temp_i)=[];
slope_Right(temp_i)=[]; % Do this for the slope and the actual start of the slope

temp_i=zeros(1,length(stSlope_Left)-1);counter=1;
for i=1:length(stSlope_Left)-1
    if stSlope_Left(i)==stSlope_Left(i+1)
    temp_i(counter)=i+1;counter=counter+1;
    end
end
temp_i=temp_i(1:counter-1);
stSlope_Left(temp_i)=[];
slope_Left(temp_i)=[]; % Do this for the slope and the actual start of the slope

%% Interpolate
if(L_Left>L_Right)
    %factor=L_Left/L_Right;
    %slope_Right_Intp1=interp1((1:L_Right)*factor,slope_Right,1:L_Left);
    slope_Right_Intp1=interp1(Stc(stSlope_Right),slope_Right,Stc(stSlope_Left));    
    avSlopes = mean([slope_Left;slope_Right_Intp1]);
    integrationCue = [stSlope_Left(1) EdSlope_Left(end)];
else %factor=L_Right/L_Left;
     slope_Left_Intp1=interp1(Stc(stSlope_Left),slope_Left,Stc(stSlope_Right));    
     avSlopes = mean([slope_Left_Intp1;slope_Right]);
     integrationCue = [stSlope_Right(1) EdSlope_Right(end)];
end

% Use both legs for speed estimation
stepAverage = 3; SpeedVector = zeros(1,length(avSlopes)-stepAverage);
for i=1:length(avSlopes)-stepAverage
    SpeedVector(i) = mean(avSlopes(i:i+stepAverage));
end

SpeedVector(isnan(SpeedVector))=[];
fs=1; %One stride per second
[B,A]=butter(2,0.3/(fs/2),'low');
%SpeedVector= 9.3516443*SpeedVector+ 4.688093945;
SpeedVector = 75.7*SpeedVector+6.15;
if(length(SpeedVector)>6)
    temp = filtfilt(B,A,SpeedVector);
    SpeedVector = reshape(temp,1,[]);    
end
%SpeedVector=SpeedVector; % Make it km/h
Speed = median(SpeedVector);  %Change to median <FIXME>
StcOut = Stc;

end