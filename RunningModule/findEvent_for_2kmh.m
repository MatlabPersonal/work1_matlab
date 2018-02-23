function [indFS,indIPA,indFF] = findEvent_for_2kmh(data,LOCS_Out,tempDelta,i)
indFS = 0;
indIPA = 0;
indFF = 0;

% find FS: 
if(LOCS_Out+tempDelta+30>length(data))
    tempFS = data(LOCS_Out:end); 
else
    tempFS = data(LOCS_Out:LOCS_Out+tempDelta+30); 
end
[~,LOCS_data]=findpeaks(tempFS,'NPeaks',5);
if(~isempty(LOCS_data))
    if(length(LOCS_data)>=2)
        temp = LOCS_data; % for debugging, the plotting below
        tempFS_recover = LOCS_data(1); % FS should be the larger peak instead of the one closest to IPA, fixed here
        peaks = zeros(1,length(LOCS_data)-1);
        nextPeakInd = zeros(1,length(LOCS_data)-1);
        for j = 2:length(LOCS_data)
            [peaks(j-1),nextPeakInd(j-1)] = findPeakNext(tempFS,LOCS_data(j),false); 
        end
        [~,peak_ind] = min(peaks);
        LOCS_data = LOCS_data(peak_ind+1);
%         indFS = LOCS_data+LOCS_Out-1;
        indFS = tempFS_recover+LOCS_Out-1;
        [~,tempIPA] = findPeakNext(tempFS,LOCS_data,false);
        indIPA = tempIPA + LOCS_Out-1;
        [~,tempFF] = findPeakNext(tempFS,tempIPA,true);
        indFF = tempFF + LOCS_Out-1;
%         if (i>100 && i<120 && true)
%             disp(temp);
%             disp(peak_ind);
%             figure;
%             plot(data); hold on;
%             plot(nextPeakInd+LOCS_Out-1,data(nextPeakInd+LOCS_Out-1),'ko');
%             plot(temp+LOCS_Out-1,data(temp+LOCS_Out-1),'go'); hold on;
%             plot(LOCS_data+LOCS_Out-1,data(LOCS_data+LOCS_Out-1),'rx'); hold on;
%         end
    else
        %LOCS_data = LOCS_data(end);
    end
end


        if (i>100 && i<120 && false)
            figure;
            plot(data); hold on;
            plot(indFS,data(indFS),'go'); hold on;
            plot(indIPA,data(indIPA),'rx'); hold on;
            plot(indFF,data(indFF),'kv'); hold on;
        end

end