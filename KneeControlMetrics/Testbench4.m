for i=1:162
%for i=[24 59]
    temp=dataSquat{i};
    start=20;
    EulerX = temp(start:end,8); angle_S = temp(start:end,9);
    gyroX = temp(start:end,5); gyroY = temp(start:end,6); gyroZ = temp(start:end,7);
    if(find(i==dataSquatLegLeft))
        tibia_angle=45;
        %display('L');
    elseif (find(i==dataSquatLegRight))
        %display('R');
        tibia_angle=-45;
    end
    movementType=1;
    [locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed,maxPostLand,minPostLand] = findMetrics(EulerX',angle_S',movementType,gyroX',gyroY',gyroZ', tibia_angle);
    % Squat
    figure;
    plot(EulerX,'linewidth',2);hold on;
    plot(angle_S,'r','linewidth',2);
    plot(locsFX,EulerX(locsFX),'rx','linewidth',2);
    plot(locsLFX,angle_S(locsLFX),'c^','linewidth',2);
    text(10,maxKneeFlexion,strcat('Speed:',num2str(speed(1))));
    text(10,maxKneeFlexion-2,strcat('FX:',num2str(maxKneeFlexion)))
    text(10,maxKneeFlexion-4,strcat('LFX_{Dev}:',num2str(devProjAngle(1))))
    text(10,maxKneeFlexion-6,strcat('LFX_{Base}:',num2str(devProjAngle(2))));
    text(10,maxKneeFlexion-8,strcat('LFX_{ROM}:',num2str(devProjAngle(3))));       
    %xlabel(num2str(i)); ylabel(num2str(l));legend(num2str(r));
    title(strcat('Squat-',num2str(i)))
    grid;

end

%%
for i=1:162
%for i=[22]
    temp=dataHop{i};
    start=20;
    EulerX = temp(start:end,8); angle_S = temp(start:end,9);
    gyroX = temp(start:end,5); gyroY = temp(start:end,6); gyroZ = temp(start:end,7);
    if(find(i==dataHopLegLeft))
        tibia_angle=45;
        %display('L');
    elseif (find(i==dataHopLegRight))
        tibia_angle=-45;
        %display('R');
    end
    movementType=2;
    [locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed] = findMetrics(EulerX',angle_S',movementType,gyroX',gyroY',gyroZ', tibia_angle);
    % Hop
    %h=figure; set(h,'Visible','off');
    figure;
    plot([EulerX angle_S],'linewidth',2);hold on;
    plot((locsFX(1:2)),EulerX(locsFX(1:2)),'rx','linewidth',2);
    plot((locsFX(3)),EulerX(locsFX(3)),'ko','linewidth',2);
    plot((locsLFX),angle_S(locsLFX),'c^','linewidth',2);
    text(10,maxKneeFlexion,strcat('Speed Pre:',num2str(speed(1))));
    text(10,maxKneeFlexion-2,strcat('Speed Post:',num2str(speed(2))));
    text(10,maxKneeFlexion-4,strcat('FX:',num2str(maxKneeFlexion)));
    text(10,maxKneeFlexion-6,strcat('LFX_{Dev}:',num2str(devProjAngle(1))));
    text(10,maxKneeFlexion-8,strcat('LFX_{Base}:',num2str(devProjAngle(2))));
    text(10,maxKneeFlexion-10,strcat('LFX_{ROM}:',num2str(devProjAngle(3))));
    text(10,maxKneeFlexion-12,strcat('LFX_{ROM_Pre}:',num2str(devProjAngle(4))));
    title(strcat('Hop-',num2str(i)))
    if(speed(1)>speed(2))
        display(strcat(num2str(i),' pre-speed'));
    else display(strcat(num2str(i),' post-speed'));
    end
    %xlabel(num2str(i)); ylabel(num2str(l));legend(num2str(r));
    grid;                   
end