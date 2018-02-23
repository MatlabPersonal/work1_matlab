function [Stc,accX,accY,accZ,gyroX,gyroY,gyroZ,tibia_angle]= formatKneeData(player,leg,type,rep)

if strcmp(type,'squat')
    if strcmp(leg,'left')
        Stc = player.left{rep}(:,1);
        accX = player.left{rep}(:,2);
        accY = player.left{rep}(:,3);
        accZ = player.left{rep}(:,4);
        gyroX = player.left{rep}(:,5);
        gyroY = player.left{rep}(:,6);
        gyroZ = player.left{rep}(:,7);
        tibia_angle=45;        
    
    elseif strcmp(leg,'right')

        Stc = player.right{rep}(:,1);
        accX = player.right{rep}(:,2);
        accY = player.right{rep}(:,3);
        accZ = player.right{rep}(:,4);
        gyroX = player.right{rep}(:,5);
        gyroY = player.right{rep}(:,6);
        gyroZ = player.right{rep}(:,7);
        tibia_angle=-45;
    end

elseif strcmp(type,'hop')
    if strcmp(leg,'left')        
        Stc = player.left{rep}(:,1);
        accX = player.left{rep}(:,2);
        accY = player.left{rep}(:,3);
        accZ = player.left{rep}(:,4);
        gyroX = player.left{rep}(:,5);
        gyroY = player.left{rep}(:,6);
        gyroZ = player.left{rep}(:,7);
        tibia_angle=45;
    elseif strcmp(leg,'right')       
        Stc = player.right{rep}(:,1);
        accX = player.right{rep}(:,2);
        accY = player.right{rep}(:,3);
        accZ = player.right{rep}(:,4);
        gyroX = player.right{rep}(:,5);
        gyroY = player.right{rep}(:,6);
        gyroZ = player.right{rep}(:,7);
        tibia_angle=-45;       
    end
end
end