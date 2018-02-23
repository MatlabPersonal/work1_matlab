function [Distance, DistanceVector] = estimateDistance(Stc, integrationCue, SpeedVector,idxSplitLeft, idxSplitRight, troughsSpeed_Left, troughsSpeed_Right)

SpeedVector = SpeedVector/3.6; %Make it m/s for integration
%speed_Interp1 = interp1(1:length(SpeedVector),SpeedVector,integrationCue(1):integrationCue(end));

% if(isempty(idxSplitLeft) && isempty(idxSplitRight))
    Stc_Speed = linspace(Stc(integrationCue(1)),Stc(integrationCue(end)),length(SpeedVector));
    Stc_Speed = (Stc_Speed-Stc_Speed(1))/1000;
    DistanceVector=cumtrapz(Stc_Speed,SpeedVector);
% else
%     %Integrate in parts
%     L=length(idxSplitLeft);
% 
%     idxSplitLeft(find(length(SpeedVector)<idxSplitLeft))=[];
%     L=length(idxSplitLeft);
%     tempDistance=zeros(1,1);
%     for i=1:L
%         if(i==1)
%             tempSpeed = SpeedVector(1:idxSplitLeft(i));
%             Stc_Speed = linspace(Stc(troughsSpeed_Left(1)),Stc(troughsSpeed_Left(idxSplitLeft(i))),length(tempSpeed));
%         else
%             tempSpeed = SpeedVector(idxSplitLeft(i-1)+1:idxSplitLeft(i)); 
%             Stc_Speed = linspace(Stc(troughsSpeed_Left(idxSplitLeft(i-1)+1)),Stc(troughsSpeed_Left(idxSplitLeft(i))),length(tempSpeed));
%         end        
%         Stc_Speed = (Stc_Speed-Stc_Speed(1))/1000;
%         tempDistance = [tempDistance (cumtrapz(Stc_Speed,tempSpeed)+tempDistance(end))];        
%     end
%     tempSpeed = SpeedVector(idxSplitLeft(i)+1:end); 
%     Stc_Speed = linspace(Stc(troughsSpeed_Left(idxSplitLeft(i)+1)),Stc(troughsSpeed_Left(end)),length(tempSpeed));
%     Stc_Speed = (Stc_Speed-Stc_Speed(1))/1000;
%     tempDistance = [tempDistance (cumtrapz(Stc_Speed,tempSpeed)+tempDistance(end))];        
%         
%     DistanceVector=tempDistance;
% end
Distance=DistanceVector(end);
end