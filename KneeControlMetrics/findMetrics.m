function [locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed,locsLandingPoint,maxPostLand,minPostLand] = findMetrics(kneeFlexion,projAngle,typeMvt,gyroX,gyroY,gyroZ,tibia_angle,ms)
[B,A]=butter(4,18/(50/2),'low');
gyroX = filtfilt(B,A,gyroX);
gyroY = filtfilt(B,A,gyroY);
gyroZ = filtfilt(B,A,gyroZ);
gyro=[gyroX;gyroY;gyroZ];
locsFX=ones(1,3); % Up to three points (2 peaks and one landing point)
locsLFX=ones(1,2);
maxKneeFlexion=0;
devProjAngle=zeros(1,5); % Up to four points (max deviation, deviation at landing point, delta max dev vs. landing point, deviation during pre hop)
locsPks=ones(1,2); valuesPks=ones(1,10); sortedIndexes=ones(1,3);
speed=zeros(1,2);
maxPostLand=0;
minPostLand=0;
locsLandingPoint=0;

LENGTH = 90;
if ((length(kneeFlexion) > LENGTH) && (length(projAngle) > LENGTH) && (length(gyroX) > LENGTH) && (length(gyroY) > LENGTH) &&  (length(gyroZ) > LENGTH))
% If squat
if(typeMvt==1)
    [valuesPks,locsPks]=findpeaksCustomized(kneeFlexion,0,10,10);
    
    if(length(locsPks)~=0)
        [~,sortedIndexes]=sort(valuesPks, 'descend');
        locsPks=locsPks(sortedIndexes(1)); %Look at the highest one
        locsPks=sort(locsPks);
        %start = locsPks(1)-30-1;       
        delta = 10; %take the first 10 samples as baseline
        baseline=mean(projAngle(delta));
        
        % Find all deviations in projected angle after landing flexion is over        
        toleranceFlexion=50; % default tolerance error
        lengthFlexionSquat = locsPks(1)+toleranceFlexion-1;
        if(length(projAngle)<=lengthFlexionSquat)
            toleranceFlexion = toleranceFlexion-(lengthFlexionSquat-length(projAngle));        
        end
        
        L = locsPks(1)+toleranceFlexion-1;
        if (length(projAngle) >= L)                      
            start=1; finish = L;% finish will be the whole length of the dataset, unless the tolerance of 50 samples is overridden 
            [~,locsMaxDev] =max(abs(projAngle(start:finish-1)-baseline));
            [~,locsMinDev] =min(abs(projAngle(start:finish-1)-baseline));
            locsMaxDev = locsMaxDev+start-1;

            locsFX(1:3) = [locsPks 1 1]; locsLFX(1) = locsMaxDev;
            devProjAngle = [projAngle(locsMaxDev) baseline projAngle(locsMaxDev)-baseline 1 1];
            maxKneeFlexion = kneeFlexion(locsPks(1));
            
            maxPostLand = projAngle(locsMaxDev)-baseline;
            minPostLand = projAngle(locsMinDev)-baseline;

            % Get speeds
            speed = getSpeedsSquat(locsMaxDev,gyro,tibia_angle);
        end
    end

% If hop
elseif (typeMvt==2)
    locsPks=findPeaksHop(kneeFlexion);
    if(length(locsPks)~=0 && length(locsPks)==2)
        temp=kneeFlexion((locsPks(1):locsPks(2)-1)');
        [~,locsLandingPoint]=min(temp);
        locsLandingPoint = locsLandingPoint+locsPks(1)-1;

        % Find all deviations in projected angle after landing flexion is over
        lengthFlexionHop = length(locsLandingPoint:locsPks(2))+locsLandingPoint-1;
        toleranceFlexion=30; % default tolerance error
        if(length(projAngle)<=lengthFlexionHop+toleranceFlexion)
            toleranceFlexion = toleranceFlexion+length(projAngle)-(lengthFlexionHop+toleranceFlexion);        
        end
        
        L = lengthFlexionHop+toleranceFlexion;
        if (length(projAngle) >= L)
            [~,locsProjPos] = max(projAngle(locsLandingPoint:locsPks(2)+toleranceFlexion));
            [~,locsProjNeg] = min(projAngle(locsLandingPoint:locsPks(2)+toleranceFlexion));    
            locsProj = locsLandingPoint+sort([locsProjPos' locsProjNeg'])-1;
            %maxPostLand = projAngle(locsProjPos);
            %minPostLand = projAngle(locsProjNeg);

            % Find the max and min deviation from landing point angle
            [~,maxIdx] = max(abs(projAngle(locsProj)-projAngle(locsLandingPoint)));   
            [~,minIdx] = min(abs(projAngle(locsProj)-projAngle(locsLandingPoint)));   
            locsMaxDev = locsProj(maxIdx);
            locsMinDev = locsProj(minIdx);
            
            maxPostLand = projAngle(locsMaxDev);
            minPostLand = projAngle(locsMinDev);

            % max and min deviation before hop
            [~,locsProjPos] = max(projAngle(1:locsLandingPoint));
            [~,locsProjNeg] = min(projAngle(1:locsLandingPoint));
            locsProj = sort([locsProjPos' locsProjNeg']);

            [~,maxIdx] = max(abs(projAngle(locsProj)-mean(projAngle(1:20))));
            locsMaxDevPre = locsProj(maxIdx);

            % Get speeds    
            speed = getSpeedsHop(locsLandingPoint,(locsPks(1)+10),locsMaxDev,gyro,tibia_angle);

            % Output
            locsLFX = [locsMaxDevPre locsMaxDev]; %If hop is detected, third value is landing point            
            locsFX(1:3) = [locsPks(1) locsPks(2) locsLandingPoint]; 
            devProjAngle = [projAngle(locsMaxDev) projAngle(locsLandingPoint) projAngle(locsMaxDev)-projAngle(locsLandingPoint) ...
                            projAngle(locsMaxDevPre)-mean(projAngle(1:5)) 1]; % Clean up
            if (kneeFlexion(locsPks(1)) > kneeFlexion(locsPks(2)))
               maxKneeFlexion = kneeFlexion(locsPks(1));
            else maxKneeFlexion = kneeFlexion(locsPks(2));
            end
        end
    end   

%if box drop
elseif (typeMvt==3)
    locsPks=findPeaksHop(kneeFlexion);
    if(length(locsPks)~=0 && length(locsPks)==2)
        temp=kneeFlexion((locsPks(1):locsPks(2)-1)');
        [~,locsLandingPoint]=min(temp);
        locsLandingPoint = locsLandingPoint+locsPks(1)-1;

        % Find all deviations in projected angle after landing flexion is over
        lengthFlexionHop = length(locsLandingPoint:locsPks(2))+locsLandingPoint-1;
        toleranceFlexion=30; % default tolerance error
        if(length(projAngle)<=lengthFlexionHop+toleranceFlexion)
            toleranceFlexion = toleranceFlexion+length(projAngle)-(lengthFlexionHop+toleranceFlexion);        
        end
        
        L = lengthFlexionHop+toleranceFlexion;
        if (length(projAngle) >= L)
            [~,locsProjPos] = max(projAngle(locsLandingPoint:locsPks(2)+toleranceFlexion));
            [~,locsProjNeg] = min(projAngle(locsLandingPoint:locsPks(2)+toleranceFlexion));    
            locsProj = locsLandingPoint+sort([locsProjPos' locsProjNeg'])-1;

            % Find the max and min deviation from landing point angle
            [~,maxIdx] = max(abs(projAngle(locsProj)-projAngle(locsLandingPoint)));   
            [~,minIdx] = min(abs(projAngle(locsProj)-projAngle(locsLandingPoint)));   
            locsMaxDev = locsProj(maxIdx);
            locsMinDev = locsProj(minIdx);
            
            maxPostLand = projAngle(locsMaxDev)-projAngle(locsLandingPoint);
            minPostLand = projAngle(locsMinDev)-projAngle(locsLandingPoint);

            % Get speeds    
            speed = getSpeedsHop(locsLandingPoint,(locsPks(1)+10),locsMaxDev,gyro,tibia_angle);

            % Output
            locsLFX = [locsMinDev locsMaxDev];          
            locsFX(1:3) = [locsPks(1) locsPks(2) locsLandingPoint]; 
            devProjAngle = [projAngle(locsMaxDev) projAngle(locsMinDev) projAngle(locsLandingPoint) ...
                            projAngle(locsMaxDev)-projAngle(locsLandingPoint) ...
                            projAngle(locsMinDev)-projAngle(locsLandingPoint)]; % devProjAngle: 1)Max 2)Min 3)landing point 4)deviation 1 5)deviation 2
            if (kneeFlexion(locsPks(1)) > kneeFlexion(locsPks(2)))
               maxKneeFlexion = kneeFlexion(locsPks(1));
            else maxKneeFlexion = kneeFlexion(locsPks(2));
            end
        end
    end 
    
%if SL box drop
elseif (typeMvt==4)
    %locsPks=findPeaksHop(kneeFlexion);
    [~,index_temp]=max(diff(kneeFlexion));
    [~,locPk]=findpeaks(kneeFlexion(index_temp:length(kneeFlexion)),'NPeaks',1,'SortStr','descend','MinPeakHeight',-10000);
    locPk=locPk+index_temp-1;
    if(length(locPk)==1)
        %find maximum of 1st order difference
        temp=kneeFlexion((1:locPk-1)');
        ms=ms((1:locPk-1)'); %time variable
        [~,locsLandingPoint]=max(diff(temp)./diff(ms));
        %adjust landing point
        locsLandingPoint=locsLandingPoint-2;
        
        % Find all deviations in projected angle after landing flexion is over
        lengthFlexionHop = length(locsLandingPoint:locPk)+locsLandingPoint-1;
        toleranceFlexion=30; % default tolerance error
        if(length(projAngle)<=lengthFlexionHop+toleranceFlexion)
            toleranceFlexion = toleranceFlexion+length(projAngle)-(lengthFlexionHop+toleranceFlexion);        
        end
        
        L = lengthFlexionHop+toleranceFlexion;
        if (length(projAngle) >= L)
            [~,locsProjPos] = max(projAngle((locsLandingPoint:locPk+toleranceFlexion)'));
            [~,locsProjNeg] = min(projAngle((locsLandingPoint:locPk+toleranceFlexion)'));    
            locsProj = locsLandingPoint+sort([locsProjPos' locsProjNeg'])-1;

            % Find the max and min deviation from landing point angle
            [~,maxIdx] = max(abs(projAngle(locsProj)-projAngle(locsLandingPoint)));   
            [~,minIdx] = min(abs(projAngle(locsProj)-projAngle(locsLandingPoint)));   
            locsMaxDev = locsProj(maxIdx);
            locsMinDev = locsProj(minIdx);
            
            maxPostLand = projAngle(locsMaxDev)-projAngle(locsLandingPoint);
            minPostLand = projAngle(locsMinDev)-projAngle(locsLandingPoint);

            % Get speeds    
%             speed = getSpeedsSquat(locsMaxDev,gyro,tibia_angle);
            speed = getSpeedsHop(locsLandingPoint,(2*locsLandingPoint - locPk+10),locsMaxDev,gyro,tibia_angle);
            % Output
            locsLFX = [locsMinDev locsMaxDev];            
            locsFX(1:3) = [locPk locsLandingPoint 1]; 
            devProjAngle = [projAngle(locsMaxDev) projAngle(locsMinDev) projAngle(locsLandingPoint) ...
                            projAngle(locsMaxDev)-projAngle(locsLandingPoint) ...
                            projAngle(locsMinDev)-projAngle(locsLandingPoint)]; % devProjAngle: 1)Max 2)Min 3)landing point 4)deviation 1 5)deviation 2
            locPk_temp=locPk(1);
            maxKneeFlexion = kneeFlexion(locPk_temp);
            
        end
    end 
end
end
end

