[locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed,locsLandingPoint,maxPostLand,minPostLand] = findMetrics(data(:,3)',data(:,4)',3,zero_gyro',zero_gyro',zero_gyro',-45,ms);
figure;
plot(data(:,3));hold on;
plot(data(:,4),'r');
plot((locsFX(1:2)),data(locsFX(1:2),3),'rx');
plot((locsFX(3)),data(locsFX(3),3),'ko');
plot((locsFX(3)),data(locsFX(3),4),'ko');
plot((locsLFX),data(locsLFX,4),'c^');