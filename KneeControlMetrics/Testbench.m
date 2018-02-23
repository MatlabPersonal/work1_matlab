% Testbench for knee control test - 17/02/2014
% acc = [accX accY accZ]; gyro = [gyroX gyroY gyroZ];
% 
% delta = 842:1186;
% Stc = Time(delta);
% accX = Ax1(delta);
% accY = Ay1(delta);
% accZ = Az1(delta);
% gyroX = Gx1(delta);
% gyroY = Gy1(delta);
% gyroZ = Gz1(delta);

% dlmwrite('ganso_hop_rep2.csv',[Stc(delta) accX accY accZ gyroX gyroY gyroZ],'precision',10);


%%
for i=13:18 %loop for saving data to xlsx
%clc;

movementType=4; 
load('AllSubjects.mat') %cell that stores all subjects
%i=1;   %index of subjects, see PlayerData.xlsx for detail

%decide j by movement type
if(movementType==4)
    j=2;   %single leg box drop
elseif(movementType==3)
    j=1;   %double leg box drop
end
%Name='Adams_Shay_right_4';
%read from cell
[Name,LeftAccX,LeftAccY,LeftAccZ,LeftFE,LeftFIG,LeftGyroX,LeftGyroY,LeftGyroZ,LeftLF,LeftLIG,RightAccX,RightAccY,RightAccZ,RightFE,RightFIG,RightGyroX,RightGyroY,RightGyroZ,RightLF,RightLIG,Stc]=ReadCell(AllSubject,i,j);

%find leading leg for box drop
[EulerX,gyroX,gyroY,gyroZ,angle_S]=decideLeadLeg(LeftFIG,RightFIG,RightGyroX,RightGyroY,RightGyroZ,RightLIG,LeftGyroX,LeftGyroY,LeftGyroZ,LeftLIG,j);
tibia_angle=45;
ms=Stc2ms(Stc);

%[EulerX,EulerY,EulerZ,angle_S] = valgus_deviation(Stc',LeftAccX',LeftAccY',LeftAccZ',LeftGyroX',LeftGyroY',LeftGyroZ',tibia_angle);


%test

[locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed,locsLandingPoint,maxPostLand,minPostLand] = findMetrics(EulerX',angle_S',movementType,gyroX',gyroY',gyroZ',-45,ms);
%[locsFX,locsLFX] = findMetrics(EulerX,angle_S,movementType);

if(movementType==1)
    % Squat
    figure;
    plot(EulerX);hold on;
    plot(angle_S,'r');
    plot(locsFX,EulerX(locsFX),'rx');
    plot(locsLFX,angle_S(locsLFX),'c^');
    title(strcat('Fx:',num2str(maxKneeFlexion)));
    xlabel(strcat('Lfx:',num2str(devProjAngle(1))));ylabel(strcat('Lfx Baseline:',num2str(devProjAngle(2))));
    legend(strcat('Lfx ROM:',num2str(devProjAngle(3))));
    grid;
    
elseif(movementType==2)
    % Hop
    figure;
    plot(EulerX);hold on;
    plot(angle_S,'r');
    plot((locsFX(1:2)),EulerX(locsFX(1:2)),'rx');
    plot((locsFX(3)),EulerX(locsFX(3)),'ko');
    plot((locsLFX),angle_S(locsLFX),'c^');
    %plot(20*sqrt(accX.^2),'k--')
    title(strcat(strcat('Fx:',num2str(maxKneeFlexion)),strcat(',Lfx:',num2str(devProjAngle))));
    
elseif(movementType==3)
    % Box Drop
    figure;
    plot(EulerX);hold on;
    plot(angle_S,'r');
    plot((locsFX(1:2)),EulerX(locsFX(1:2)),'rx');
    plot((locsFX(3)),EulerX(locsFX(3)),'ko');
    plot((locsFX(3)),angle_S(locsFX(3)),'ko');
    plot((locsLFX),angle_S(locsLFX),'c^');
    if(isequal(angle_S,LeftLIG))
        angle_S=RightLIG;  
        LRflag=1;
        plot(angle_S,'g');
        [~,locsRFX,~,devProjAngleR,~,locsLandingPointR,~,~] = findMetrics(EulerX',angle_S',movementType,gyroX',gyroY',gyroZ',-45,ms);
        plot((locsRFX),angle_S(locsRFX),'b^');
        if(locsLandingPointR~=0)
          plot(locsLandingPointR,angle_S(locsLandingPointR),'ko');
          fprintf('Left Leg: %f,%f\n',devProjAngle(4),devProjAngle(5));
          fprintf('Right Leg: %f,%f\n',devProjAngleR(4),devProjAngleR(5));
          fprintf('speed: %f\n',speed(1));
%          [xlRange,xlRange2]=Write2SpreadSheet(i,movementType,1,'PlayerData.xlsx',devProjAngle(4),devProjAngleR(4));
%          fprintf('data saved to "%s" and "%s" in file: "PlayerData.xlsx"\n',xlRange,xlRange2);
        else
          fprintf('insufficient data\n');
%           [~,~]=Write2SpreadSheet(i,movementType,1,'PlayerData.xlsx',{'N/A'},{'N/A'});
        end
         titleName=regexprep(Name,'_',' ');
         title({titleName;strcat('Fx:',num2str(maxKneeFlexion));'           Max             Min              LP           dev1        dev2';strcat('Lfx :',num2str(devProjAngle));strcat('Rfx:',num2str(devProjAngleR))});
         legend('Left F','Left L','Peaks','LP','LP','Max Min right','Right L','Max min left','LP');
         grid on;
    else
        angle_S=LeftLIG;
        LRflag=0;
        plot(angle_S,'g');
        [~,locsRFX,~,devProjAngleR,~,locsLandingPointR,~,~] = findMetrics(EulerX',angle_S',movementType,gyroX',gyroY',gyroZ',-45,ms);
        plot((locsRFX),angle_S(locsRFX),'b^');
        if(locsLandingPointR~=0)
          plot(locsLandingPointR,angle_S(locsLandingPointR),'ko');
          fprintf('Right Leg: %f,%f\n',devProjAngle(4),devProjAngle(5));
          fprintf('Left Leg: %f,%f\n',devProjAngleR(4),devProjAngleR(5));
          fprintf('speed: %f\n',speed(1));
%            [xlRange,xlRange2]=Write2SpreadSheet(i,movementType,1,'PlayerData.xlsx',devProjAngleR(4),devProjAngle(4));
%            fprintf('data saved to "%s" and "%s" in file: "PlayerData.xlsx"\n',xlRange,xlRange2);
        else
          fprintf('insufficient data\n');
%          [~,~]=Write2SpreadSheet(i,movementType,1,'PlayerData.xlsx',{'N/A'},{'N/A'});
        end
        titleName=regexprep(Name,'_',' ');
        title({titleName;strcat('Fx:',num2str(maxKneeFlexion));'           Max             Min              LP           dev1        dev2';strcat('Rfx :',num2str(devProjAngle));strcat('Lfx:',num2str(devProjAngleR))});
        legend('Right F','Right L','Peaks','LP','LP','Max Min left','Left L','Max min right','LP');
        grid on;
    end

   
elseif(movementType==4)
    % SL Box Drop
    figure;
    plot(EulerX);hold on;
    plot(angle_S,'r');
    plot((locsFX(1)),EulerX(locsFX(1)),'rx');
    plot((locsFX(2)),EulerX(locsFX(2)),'ko');
    plot((locsFX(2)),angle_S(locsFX(2)),'ko');
    plot((locsLFX),angle_S(locsLFX),'c^');
    titleName=regexprep(Name,'_',' ');
    title({titleName;strcat('Fx:',num2str(maxKneeFlexion));'        Max           Min           LP           dev1           dev2';strcat('Lfx:',num2str(devProjAngle))});
    grid on;
    fprintf('Max Devs: %f,%f\n',devProjAngle(4),devProjAngle(5));
    fprintf('speed: %f\n',speed(1));
%      [xlRange,~]=Write2SpreadSheet(i,movementType,1,'PlayerData.xlsx',devProjAngle(4),0);
%      fprintf('data saved to "%s" in file: "PlayerData.xlsx"\n',xlRange);
end
end

