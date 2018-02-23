%function speeds = getSpeedsHop(stc,projAngle,locsLandingPoint,preHopFlexion,locsMaxDev)
function speeds = getSpeedsHop(locsLandingPoint,preHopFlexion,locsMaxDev,gyro,tibia_angle)

%stc=stc-stc(1);
timePre = (1:preHopFlexion);
timePost = (locsLandingPoint:locsMaxDev);
% deltaPre = diff(stc(timePre))/1000;
% deltaPost = diff(stc(timePost))/1000;
% deltaProjPre = diff(projAngle(timePre));
% deltaProjPost = diff(projAngle(timePost));
% 
% speedsMaxPre = max(deltaProjPre./deltaPre);
% speedsMinPre = min(deltaProjPre./deltaPre);
% speedsMaxPost = max(deltaProjPost./deltaPost);
% speedsMinPost = min(deltaProjPost./deltaPost);
% 
% speeds = zeros(1,2);
% if abs(speedsMaxPre) > abs(speedsMinPre) 
%     speeds(1) = speedsMaxPre;
% else speeds(1) = speedsMinPre; 
% end
% 
% if abs(speedsMaxPost) > abs(speedsMinPost) 
%     speeds(2) = speedsMaxPost;
% else speeds(2) = speedsMinPost; 
% end
% 
% % Output the absolute regardless of its direction
% speeds = abs(speeds);

%%
% timePre =  abs(stc(1)-stc(preHopFlexion));
% timePost = abs(stc(locsLandingPoint)-stc(locsMaxDev));
% deltaPre = projAngle(preHopFlexion) - projAngle(1);
% deltaPost = projAngle(locsMaxDev) - projAngle(locsLandingPoint);
% speeds(1)=abs(deltaPre/(timePre/1000));
% speeds(2)=abs(deltaPost/(timePost/1000));
gyro=gyro';

gyroTA = zeros(length(gyro),3);
[gyroTA(:,3),gyroTA(:,2)]=vt(gyro(:,3),gyro(:,2),tibia_angle);
speedMedioLateral=gyroTA(:,2);

speedsMaxPre = max(speedMedioLateral(timePre));
speedsMinPre = min(speedMedioLateral(timePre));
speedsMaxPost = max(speedMedioLateral(timePost));
speedsMinPost = min(speedMedioLateral(timePost));

speeds = zeros(1,2);
if abs(speedsMaxPre) > abs(speedsMinPre)
    speeds(1) = speedsMaxPre;
else speeds(1) = speedsMinPre;
end

if abs(speedsMaxPost) > abs(speedsMinPost) 
    speeds(2) = speedsMaxPost;
else speeds(2) = speedsMinPost; 
end

% Output the absolute regardless of its direction
speeds = abs(speeds);

% figure;
% plot(gyro); hold on;
% plot(gyroTA(:,2),'c','linewidth',2);
% plot(locsLandingPoint,gyro(locsLandingPoint),'rx')
% plot(preHopFlexion, gyro(preHopFlexion),'ko');
% text(10,speeds(1)+20,strcat('Speed Max Pre:',num2str(speedsMaxPre)));
% text(10,speeds(1)+40,strcat('Speed Min Pre:',num2str(speedsMinPre)));
% text(10,speeds(1)+60,strcat('Speed Max Post:',num2str(speedsMaxPost)));
% text(10,speeds(1)+80,strcat('Speed Min Post:',num2str(speedsMinPost)));
% legend('gyroX','gyroY','gyroZ','tf gyroY','landpt','preHopFX');grid;


end