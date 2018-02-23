
n=1000; t=1000;
(tic);
for i=1:n
    for k=1:2
        for l=1:3
            movementType=3;
            L=randi(3000,1,1);
            % Generate random inputs
%             display(i);
%             display(k);
%             display(l);
%             display(L);
%             display(movementType);
            
%             if(rem(i,2)==0)
%                 EulerX = linspace(1,L,L);
%                 angle_S = linspace(1,-L,L);
%                 gyroX = linspace(1,L,L);
%                 gyroY = linspace(1,-L,L);
%                 gyroZ = linspace(1,L,L);  
%                 ms = linspace(1,L,L)
                %tibia_angle = ;
%            elseif(rem(i,3)==0)
%                 EulerX = sawtooth(1:L);
%                 angle_S = sawtooth(1:L);
%                 gyroX = sawtooth(1:L);
%                 gyroY = sawtooth(1:L);
%                 gyroZ = sawtooth(1:L); 
%                 ms = sawtooth(1:L);
%             elseif(rem(i,4)==0)                        
%                 EulerX = sin(linspace(1,L,L));
%                 angle_S = sin(linspace(1,L,L));
%                 gyroX = sin(linspace(1,L,L));
%                 gyroY = sin(linspace(1,L,L));
%                 gyroZ = sin(linspace(1,L,L));
%                 ms = sin(linspace(1,L,L)); 
%             elseif(rem(i,5)==0)                                    
                EulerX = zeros(1,L);
                angle_S = zeros(1,L);
                gyroX = zeros(1,L);
                gyroY = zeros(1,L);
                gyroZ = zeros(1,L);
                ms = zeros(1,L);
%             else
%                 EulerX = rand(1,L);
%                 angle_S = rand(1,L);
%                 gyroX = rand(1,L);
%                 gyroY = rand(1,L);
%                 gyroZ = rand(1,L);
%                 ms = rand(1,L);
%             end
            
            tibia_angle=45;
            [locsFX,locsLFX,maxKneeFlexion,devProjAngle,speed,maxPostLand,minPostLand] = findMetrics(EulerX,angle_S,movementType,gyroX,gyroY,gyroZ,tibia_angle,ms);
            
%             if(movementType==1)
%                 % Squat
%                 figure;
%                 plot(EulerX);hold on;
%                 plot(angle_S,'r');
%                 plot(locsFX,EulerX(locsFX),'rx');
%                 plot(locsLFX,angle_S(locsLFX),'c^');
%                 title(strcat('Fx:',num2str(maxKneeFlexion)));
%                 xlabel(strcat('Lfx:',num2str(devProjAngle(1))));ylabel(strcat('Lfx Baseline:',num2str(devProjAngle(2))));
%                 legend(strcat('Lfx ROM:',num2str(devProjAngle(3))));
%                 grid;
% 
%             elseif(movementType==2)
%                 % Hop
%                 figure;
%                 plot([EulerX' angle_S']);hold on;
%                 plot((locsFX(1:2)),EulerX(locsFX(1:2)),'rx');
%                 plot((locsFX(3)),EulerX(locsFX(3)),'ko');
%                 plot((locsLFX),angle_S(locsLFX),'c^');    
%                 %plot(20*sqrt(accX.^2),'k--')
%                 title(strcat(strcat('Fx:',num2str(maxKneeFlexion)),strcat(',Lfx:',num2str(devProjAngle))));
             
%             elseif(movementType==3)
             % Box Drop
%              figure;
%              plot(EulerX);hold on;
%              plot(angle_S,'r');
%              plot((locsFX(1:2)),EulerX(locsFX(1:2)),'rx');
%              plot((locsFX(3)),EulerX(locsFX(3)),'ko');
%              plot((locsFX(3)),angle_S(locsFX(3)),'ko');
%              plot((locsLFX),angle_S(locsLFX),'c^');
%              if(isequal(angle_S,LeftLIG))
%                  angle_S=RightLIG;  
%                  LRflag=1;
%                  plot(angle_S,'g');
%                  [~,locsRFX,~,devProjAngleR,~,locsLandingPointR,~,~] = findMetrics(EulerX,angle_S,movementType,gyroX',gyroY',gyroZ',-45,ms);
%                  plot((locsRFX),angle_S(locsRFX),'b^');
%                  if(locsLandingPointR~=0)
%                      plot(locsLandingPointR,angle_S(locsLandingPointR),'ko');
%                      fprintf('Left Leg: %f,%f\n',devProjAngle(4),devProjAngle(5));
%                      fprintf('Right Leg: %f,%f\n',devProjAngleR(4),devProjAngleR(5));
%                  else
%                      fprintf('insufficient data\n');
%                  end
%                  titleName=regexprep(Name,'_',' ');
%                  title({titleName;strcat('Fx:',num2str(maxKneeFlexion));'           Max             Min              LP           dev1        dev2';strcat('Lfx :',num2str(devProjAngle));strcat('Rfx:',num2str(devProjAngleR))});
%                  legend('Left F','Left L','Peaks','LP','LP','Max Min right','Right L','Max min left','LP');
%                  grid on;
%              else
%                  angle_S=LeftLIG;
%                  LRflag=0;
%                  plot(angle_S,'g');
%                  [~,locsRFX,~,devProjAngleR,~,locsLandingPointR,~,~] = findMetrics(EulerX,angle_S,movementType,gyroX',gyroY',gyroZ',-45,ms);
%                  plot((locsRFX),angle_S(locsRFX),'b^');
%                  if(locsLandingPointR~=0)
%                  plot(locsLandingPointR,angle_S(locsLandingPointR),'ko');
%                  fprintf('Right Leg: %f,%f\n',devProjAngle(4),devProjAngle(5));
%                  fprintf('Left Leg: %f,%f\n',devProjAngleR(4),devProjAngleR(5));
%                  else
%                  fprintf('insufficient data\n');
%                  end
%                  titleName=regexprep(Name,'_',' ');
%                  title({titleName;strcat('Fx:',num2str(maxKneeFlexion));'           Max             Min              LP           dev1        dev2';strcat('Rfx :',num2str(devProjAngle));strcat('Lfx:',num2str(devProjAngleR))});
%                  legend('Right F','Right L','Peaks','LP','LP','Max Min left','Left L','Max min right','LP');
%                  grid on;
%              end
%            end
        end
    end
end
(toc);