function [indFF,indIPA,indFS,indTO, stSlope, edSlope,indTroughsSpeed] = findEvents_V2(Stc,data, swingWav, stanceWav_IPADiff,energy,troughsSpeed,energyThreshold)%,...
%                                                                          FootStrike_True, InitPeakAcc_True, FlatFoot_True, stSlope_True, EdSlope_True, ToeOff_True)
% indFF=0;indIPA=0;indFS=0;indTO=0; stSlope=0; edSlope=0;indTroughsSpeed=0;
%%.0 Find Start and End of Slope
indZeroSwingWav=crossing(swingWav)';
tempCounter = 0;
% figure;
% plot(swingWav);
% hold on;
% plot(indZeroSwingWav,swingWav(indZeroSwingWav),'ro');
if(~isempty(indZeroSwingWav))
backupIndZeroSwingWav = indZeroSwingWav;
MPD = 30; [~,locsSW] = findpeaks(swingWav,'MinPeakDistance',MPD);

derivSwingWav = (diff(swingWav)./diff(Stc));
% 
% figure;
% plot(derivSwingWav); hold on;
% plot(indZeroSwingWav,derivSwingWav(indZeroSwingWav),'ro');
% stophere;


indZeroSwingWav(derivSwingWav(indZeroSwingWav) < 0)=[]; % If derivative is negative, then exclude
indZeroSwingWav(derivSwingWav(indZeroSwingWav) < 0.01)=[]; % Derek: changed to 0.01 for walking speed was 0.04                                           
locsSW=locsSW';
L=length(indZeroSwingWav);temp=zeros(1,L);
for k=1:L
    if(all(any(locsSW>indZeroSwingWav(k))))
        first = min(locsSW((locsSW>indZeroSwingWav(k))));
        if(~isempty(first)) %<FIXME: Move this to findEvents?>
            temp(k) = first;
        end
    else
        temp(k)=0;
    end
end
locsSW=temp(1:L); %clear temp; % This is actually the StSlope
% indZeroSwingWav(locsSW==0)=[]; % Start of Slope and End of Slope have to be in order
% locsSW(locsSW==0)=[]; % Start of Slope and End of Slope have to be the same

edSlope = locsSW(locsSW~=0);
stSlope = indZeroSwingWav';

% figure;
% plot(swingWav); hold on;
% plot(edSlope,swingWav(edSlope),'ro'); hold on;
% plot(stSlope,swingWav(stSlope),'kx'); hold on;

indZeroSwingWav = backupIndZeroSwingWav;
%% 1. Find negative swing

% Make sure it is negative
k=1;
counterMisdetected = 1;
L = length(data);
misLOCS_data_Out=zeros(1,L);
CorrectedLOCS_data_Out=zeros(1,L);
indFF=zeros(1,L);
LOCS_Out=zeros(1,L);
percentageLOCS=zeros(1,L);

rangeIPA=15; % was 5
rangeFS=20; %was 10
rangeTO=5;
indIPA=zeros(1,L); 
indFS=zeros(1,L);
indTO=zeros(1,L);
% indTroughsSpeed=zeros(1,L);
if swingWav(indZeroSwingWav(1)+1) < 0
    start = 1;
else start = 2;
end
end1 = length(indZeroSwingWav)-1;

% start = 150;
% end1 = 154;
for i=start:2:end1
    
    %% 2. Find the maximum peaks within that region   
    delta = indZeroSwingWav(i):indZeroSwingWav(i+1);    

    %[~,LOCS]=findpeaks(stanceWav_IPA(delta));
    if (length(delta) > 3)
%     [~,LOCS]=findpeaks(stanceWav_IPADiff(delta));
    LOCS=find(diff(diff(stanceWav_IPADiff(delta))>0)<0)+1;    
%     figure;
%     plot(stanceWav_IPADiff(delta)); hold on;
%     plot(LOCS,stanceWav_IPADiff(delta(LOCS)),'rx');
    
    locsPercentage = LOCS/length(delta);

    %% 3. Exclude the ones that are not in a specific range (0 - 55% of the negative area of swing phase)
    LOCS(locsPercentage>1.0)=[]; %was 1.0
    LOCS(locsPercentage<0.1)=[]; %was 0.2

    %plot(LOCS,stanceWav_IPA(delta(LOCS)),'ko');
    [~,I] = sort(stanceWav_IPADiff(delta(LOCS)),'descend');
            
        if (length(LOCS) >= 1)
            %display(i);
            %LOCS_Out(k) = LOCS(2); % Check only the first two
            LOCS_Out(k) = LOCS(I(1)); % Check only the first two
            %plot(LOCS_Out,stanceWav_IPA(delta(LOCS_Out)),'go');
            LOCS_Out(k) = LOCS_Out(k) + indZeroSwingWav(i) - 1;

            %% 4. Find the Flat Foot Event that comes near that positive peak
%             display(k)
            tempDelta = length(delta) - LOCS(I(1));
            if(tempDelta > 3)
                %                 [~,LOCS_data]=findpeaks(data(LOCS_Out(k):LOCS_Out(k)+tempDelta-1),'NPeaks',1);
                tempFF = data(LOCS_Out(k):LOCS_Out(k)+tempDelta-1); % derek: was -1. extended range for walking 2km/
                isLowSpeed = detectLowSpeed(data,LOCS_Out(k),tempDelta);
%                 disp(isLowSpeed);
                if(~isLowSpeed) % in here if higher than 2km/h
                    [~,LOCS_data]=findpeaks(tempFF,'NPeaks',2);
                    
                    if(~isempty(LOCS_data))
                        
                        [~,I]=sort(tempFF(LOCS_data),'descend');
                        
                        
                        % for debugging
                        if (i>100 && i<120 && false)
                            figure;
                            %                         plot(tempFF); hold on;
                            %                         plot(LOCS_data(I),tempFF(LOCS_data(I)),'rx');
                            plot(data); hold on;
                            plot(LOCS_data(I)+LOCS_Out(k)-1,data(LOCS_data(I)+LOCS_Out(k)-1),'ro'); hold on;
                            plot(length(tempFF)+LOCS_Out(k)-1,data(length(tempFF)+LOCS_Out(k)-1),'gx');
                        end
                        
                        %                     LOCS_data = LOCS_data(I(1));
                        LOCS_data = selectFF(LOCS_data,tempFF,I); % derek: adjusted for finding correct event for walking
                        indFF(k) = LOCS_data+LOCS_Out(k)-1;
                        
                        %% 5. Fix misdetected ones
                        temp = indFF(k) - (indZeroSwingWav(i));
                        % display(i);display(k);
                        percentageLOCS(k) = temp/length(delta);
                        
                        if ((percentageLOCS(k) > 1.0) && data(delta(temp)) < 0)
                            misLOCS_data_Out(counterMisdetected) =  indFF(k);
                            %display(misLOCS_data_Out(counterMisdetected));
                            
                            % Use the other peak
                            if(length(I)>=2)
                                LOCS_Out(k) = LOCS(I(2));
                                LOCS_Out(k) = LOCS_Out(k) + indZeroSwingWav(i) - 1;
                                %                             [~,LOCS_data]=findpeaks(data(LOCS_Out(k):LOCS_Out(k)+3),'NPeaks',1);
                                [~,LOCS_data]=findpeaks(data(LOCS_Out(k):LOCS_Out(k)+3),'NPeaks',1);
                                if(~isempty(LOCS_data))
                                    indFF(k) = LOCS_data+LOCS_Out(k)-1;
                                    CorrectedLOCS_data_Out(counterMisdetected) = indFF(k);
                                    counterMisdetected = counterMisdetected + 1;
                                end
                            end
                        end
                        
                        %% Find IPA
                        FF = indFF(k)-indZeroSwingWav(i)+1;
                        if (FF<=rangeIPA)
                            searchDelta = FF-1;
                        else searchDelta = rangeIPA;
                        end
                        
                        tempDelta=delta(FF-searchDelta):delta(FF);
                        
                        if(length(tempDelta)>3)
                            
                            %                     [~,x]=findpeaks(-data(tempDelta')','NPeaks',1);
                            [~,x]=findpeaks(-data(tempDelta')','NPeaks',5);
                            %                    figure;
                            %                    plot(-data(tempDelta));
                            %                    hold on;
                            %                    plot(x,-data(x),'ro');
                            if(~isempty(x))
                                [~,I]=sort(-data(tempDelta(x)),'descend');
                                %                         [~,I]=max(-data(tempDelta(x)));
                                x = x(I(1));
                                
                                tempIPA = x(1);
                                tempIPA = FF-searchDelta+tempIPA-1;
                                indIPA(k) = tempIPA + indZeroSwingWav(i) - 1;
                                
                                %% Find FS
                                if (tempIPA <= rangeFS)
                                    searchDelta=tempIPA-1;
                                else searchDelta = rangeFS;
                                end
                                
                                extraRange = 5; %Derek: for walking
                                tempDelta=data(delta(tempIPA-searchDelta)-extraRange:delta(tempIPA));
                                %                         figure;
                                %                         plot(tempDelta);
                                if(length(tempDelta)>3)
                                    %                             [~,tempFS]=findpeaks(tempDelta,'NPeaks',1);
                                    [~,tempFS]=findpeaks(tempDelta,'NPeaks',5);
                                    if(~isempty(tempFS))
                                        %                                 [~,I]=sort(tempDelta(tempFS),'descend');
                                        [~,I]=sort(tempFS,'descend');
                                        tempFS = tempFS(I(1));
                                        tempFS = tempIPA-searchDelta+tempFS-1;
                                        indFS(k) = tempFS + indZeroSwingWav(i) - extraRange -1;
                                    end
                                end
                            end
                        end
                        
                        k=k+1;
                    end
                elseif(min(tempFF)<-1.2)
                    % in here if speed slower than 2km/h
                    [indFS(k),indIPA(k),indFF(k)] = findEvent_for_2kmh(data,LOCS_Out(k),tempDelta,i);
                    k=k+1;
                    tempCounter = tempCounter + 1;
                end
            end
        end
    end
end



%% Find TO
% indFF(swingWav(indFF) > -1.5)=[];
indFF(indFF==0)=[];
indIPA(indIPA==0)=[];
indFS(indFS==0)=[];

indIPA(data(indIPA)>-1.2) = [];
[indFF,indIPA,indFS] = matchEvents(indFF,indIPA,indFS);

% if(false)
%     disp(size(indIPA));
%     disp(size(indFF));
%     disp(size(indFS));
%     figure;
%     plot(data); hold on;
%     plot(indFF,data(indFF),'ro'); hold on;
%     plot(indFS,data(indFS),'go'); hold on;
%     plot(indIPA,data(indIPA),'ko'); hold on;
% end

stSlope(stSlope==0)=[];
edSlope(edSlope==0)=[];

% % Find energy of Swing
% energyThreshold = 8;
window_size2=0;
window_size1=80;



indTroughsSpeed=troughsSpeed;
[indTO,stSlope,edSlope,indFS] = findTO(data,indFS);

indIPA(indFS==0) = [];
indFF(indFS==0) = [];
indFS(indFS==0) = [];
% 
% if (data(indIPA)<-1.5) %if more than 2km/h, otherwise goes in else
%     indFF(energy(max(indFF-window_size1,1))<energyThreshold & energy(min(indFF+window_size2,length(energy)))<energyThreshold) = [];
%     indIPA(energy(max(indIPA-window_size1,1))<energyThreshold & energy(min(indIPA+window_size2,length(energy)))<energyThreshold) = [];
%     indFS(energy(max(indFS-window_size1,1))<energyThreshold & energy(min(indFS+window_size2,length(energy)))<energyThreshold) = [];
%     stSlope(energy(max(stSlope-window_size1,1))<energyThreshold & energy(min(stSlope+window_size2,length(energy)))<energyThreshold) = [];
%     edSlope(energy(max(edSlope-window_size1,1))<energyThreshold & energy(min(edSlope+window_size2,length(energy)))<energyThreshold) = [];
%     troughsSpeed(energy(max(troughsSpeed-window_size1,1))<energyThreshold & energy(max(min(troughsSpeed+window_size2,length(energy)),1))<energyThreshold) = [];
%     indTroughsSpeed=troughsSpeed;
%     
%     % Get rid of unwanted -1 values for log
%     dataFF=data(indFF);
%     indFF((dataFF+1)<0)=[];
%     
%     % Check start and end of ranges
%     if(~isempty(stSlope) && ~isempty(edSlope))
%         deltaTO=5;
%         if(deltaTO >= stSlope(1))
%             deltaTO = stSlope(1)-1;
%         end
%         deltaTO_End=5;
%         if(deltaTO_End >= (length(data)-stSlope(end)))
%             deltaTO_End = length(data)-stSlope(end);
%         end
%         
%         for i=1:length(stSlope)
%             strideStance = data(stSlope(i)-deltaTO:stSlope(i)+deltaTO_End);
%             %     [~,I] = findpeaks(strideStance,'npeaks',3);
%             [~,I] = findpeaks(strideStance,'npeaks',3);
%             
%             %     strideOut{i}=strideStance;
%             if(~isempty(I))
%                 [~,T] = max(strideStance(I));
%                 indTO(i) = stSlope(i) - deltaTO + I(T(1)) - 1;
%             end
%         end
%         indTO(indTO==0)=[];
%         
%         % Remove unnecessary Gait Events
%         if(~isempty(indFF) && ~isempty(indIPA) && ~isempty(indFS) && ~isempty(indTO))
%             indFF(indFF < edSlope(1))=[];
%             indIPA(indIPA < edSlope(1))=[];
%             indFS(indFS < edSlope(1))=[];
%             indTO(indTO < edSlope(1))=[];
%             
%             % indFF(indFF > edSlope(end))=[];
%             % indIPA(indIPA > edSlope(end))=[];
%             % indFS(indFS > edSlope(end))=[];
%             % indTO(indTO > edSlope(end))=[];
%             
%             if(~isempty(indFF) && ~isempty(indIPA) && ~isempty(indFS) && ~isempty(indTO))
%                 % Synchronize FS and TO - find pairwise
%                 indTO(indFS(1)>indTO)=[];   % Start from the first FS
%                 if(~isempty(indTO))
%                     indFS(indTO(end)<indFS)=[]; % Finish at the last TO
%                     indxTO=zeros(1,length(indFS));
%                     
%                     for i=1:length(indFS)
%                         temp = min(find(indFS(i)<indTO));
%                         if(~isempty(temp))
%                             indxTO(i) = temp;
%                         end
%                     end
%                     indxTO(indxTO==0)=[];
%                     indTO=indTO(indxTO);
%                 end
%             end
%             
%         end
%         % if(length(indTO)~=length(indFS))
%         %     display('Problem!')
%         % end
%     end
% else % if is below 2km/h
%     indFF(data(indIPA)>-1.2) = [];
%     indFS(data(indIPA)>-1.2) = [];
%     indIPA(data(indIPA)>-1.2) = [];
%     indTroughsSpeed=troughsSpeed;
%     
%     % Get rid of unwanted -1 values for log
%     dataFF=data(indFF);
%     indFF((dataFF+1)<0)=[];
%     
%     % Check start and end of ranges
%     if(~isempty(stSlope) && ~isempty(edSlope))
%         deltaTO=5;
%         if(deltaTO >= stSlope(1))
%             deltaTO = stSlope(1)-1;
%         end
%         deltaTO_End=5;
%         if(deltaTO_End >= (length(data)-stSlope(end)))
%             deltaTO_End = length(data)-stSlope(end);
%         end
%         
%         for i=1:length(stSlope)
%             strideStance = data(stSlope(i)-deltaTO:stSlope(i)+deltaTO_End);
%             %     [~,I] = findpeaks(strideStance,'npeaks',3);
%             [~,I] = findpeaks(strideStance,'npeaks',3);
%             
%             %     strideOut{i}=strideStance;
%             if(~isempty(I))
%                 [~,T] = max(strideStance(I));
%                 indTO(i) = stSlope(i) - deltaTO + I(T(1)) - 1;
%             end
%         end
%         indTO(indTO==0)=[];
%         
%         % Remove unnecessary Gait Events
%         if(~isempty(indFF) && ~isempty(indIPA) && ~isempty(indFS) && ~isempty(indTO))
%             indFF(indFF < edSlope(1))=[];
%             indIPA(indIPA < edSlope(1))=[];
%             indFS(indFS < edSlope(1))=[];
%             indTO(indTO < edSlope(1))=[];
%             
%             % indFF(indFF > edSlope(end))=[];
%             % indIPA(indIPA > edSlope(end))=[];
%             % indFS(indFS > edSlope(end))=[];
%             % indTO(indTO > edSlope(end))=[];
%             
%             if(~isempty(indFF) && ~isempty(indIPA) && ~isempty(indFS) && ~isempty(indTO))
%                 % Synchronize FS and TO - find pairwise
%                 indTO(indFS(1)>indTO)=[];   % Start from the first FS
%                 if(~isempty(indTO))
%                     indFS(indTO(end)<indFS)=[]; % Finish at the last TO
%                     indxTO=zeros(1,length(indFS));
%                     
%                     for i=1:length(indFS)
%                         temp = min(find(indFS(i)<indTO));
%                         if(~isempty(temp))
%                             indxTO(i) = temp;
%                         end
%                     end
%                     indxTO(indxTO==0)=[];
%                     indTO=indTO(indxTO);
%                 end
%             end
%             
%         end
%         % if(length(indTO)~=length(indFS))
%         %     display('Problem!')
%         % end
%     end
% end


else
    indFF=0;indIPA=0;indFS=0;indTO=0; stSlope=0; edSlope=0;indTroughsSpeed=0;
end

end