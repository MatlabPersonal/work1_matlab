%% ------------------------------------------------------------------------
% function [out,page_info,timeInterp] 
%   = interpDataOverPage(in,type,page_info,interp_size)
% try allcoate a timeStamp for each data point of an input array and
% construct a time array same size of input data. Then interpolate both
% input array and time array to size of 'interp_size'
%
% INPUTs:
% in - input array
% type - sensor type, refer to sensor flags in process_bin.m
% page_info - information of each page, refer to page_info in process_bin.m
% interp_size: output array size
%
% OUTPUTs:
% out - output array
% page_info - modified page_info, after interpolation
% timeInterp - time array constructed
% -------------------------------------------------------------------------
function [out,page_info,timeInterp] = interpDataOverPage(in,type,page_info,interp_size)
if(type ~= 5)
    % if input sensor is not emg, i.e. has 3 axis
    if(type == 4 || type == 5)
        % emg and high g sensor type is not consistant with page_info
        type = type + 1;
    end
    % calculate sampling rate of this sensor
    rate = sum(page_info(:,type))*1000/page_info(end,4);
    % th - expected time duration of each page
    th = median(diff(page_info(:,4))) * 1.5;
    % page_sample_med_in - expected number of samples from each page
    page_sample_med_in = median(page_info(:,type));
    % initialise corrupted and lost page counter
    num_corr = 0;
    num_lost = 0;
    nbr_of_pages = size(page_info,1);
    for i = 1:nbr_of_pages-1
        current_page = nbr_of_pages - i;
        if(page_info(current_page,type) < round(page_sample_med_in*0.9))
            % consider corrupted_page if number of samples smaller than 90%
            % of expected samples
            cursor_in = sum(page_info(1:current_page,type));
            % fill in the gap to expected num of samples
            in_interp_temp = [linspace(in(cursor_in-1,1),in(cursor_in+1,1),page_sample_med_in - page_info(current_page,type))' ...
                linspace(in(cursor_in-1,2),in(cursor_in+1,2),page_sample_med_in - page_info(current_page,type))' ...
                linspace(in(cursor_in-1,3),in(cursor_in+1,3),page_sample_med_in - page_info(current_page,type))'];
            in = [in(1:cursor_in,:);in_interp_temp;in(cursor_in+1:end,:)];
            page_info(current_page,type) = page_sample_med_in;
            num_corr = num_corr + 1;
        end
        if(page_info(current_page + 1,4) - page_info(current_page,4)> th)
            % consider lost page if time duration gap greater than th
            cursor_in = sum(page_info(1:current_page,type));
            % fill in whole page with linear interpolation
            in_interp_temp = [linspace(in(cursor_in-1,1),in(cursor_in+1,1),page_sample_med_in)'...
                linspace(in(cursor_in-1,2),in(cursor_in+1,2),page_sample_med_in)'...
                linspace(in(cursor_in-1,3),in(cursor_in+1,3),page_sample_med_in)'];
            in = [in(1:cursor_in,:);in_interp_temp;in(cursor_in+1:end,:)];
            page_info(current_page,type) = page_info(current_page,type)+page_sample_med_in;
            num_lost = num_lost + 1;
        end
    end
    % estimate session end time
    estimated_end_time = median(diff(page_info(:,4)))*page_info(end,1)/median(page_info(:,type)) + page_info(end,4);
    n = interp_size;
    timeInterp = linspace(1,estimated_end_time,n); 
    timeStamp = [page_info(2:end,4); mean(diff(page_info(:,4)))*page_info(end,1)/mean(page_info(:,type))+page_info(end,4)]; %estimate the last timeStamp
    inTime = zeros(1,sum(page_info(:,type)));
    inTimeIndexTemp = cumsum(page_info(:,type));
    % estimate time of first page
    inTime(1:inTimeIndexTemp(1)) = linspace(1,timeStamp(1),page_info(1,type));
    average_sample_time = 1000/rate;
    % estimate time of the rest of the pages
    for i = 2:nbr_of_pages
        inTime(inTimeIndexTemp(i-1)+1:inTimeIndexTemp(i)) = linspace(timeStamp(i-1)+average_sample_time,timeStamp(i),page_info(i,type)); %timeStamp(i-1)+average_sample_time:(timeStamp(i) - timeStamp(i-1)-average_sample_time)/page_info(i,1):timeStamp(i);
    end
    % force timestamp to be monotonic increase, very unlikely to be called
%     [inTime] = forceMonotonicIncrease(inTime);
    % interpolate array to expected size
    out = interp1(inTime,in,timeInterp);
else
    % type is EMG sensor: same as above except for there is only one axis
    % worth of data interpolated.
    if(type == 4 || type == 5)
        type = type + 1;
    end
    rate = sum(page_info(:,type))*1000/page_info(end,4);
    th = median(diff(page_info(:,4))) * 1.5;
    page_sample_med_in = median(page_info(:,type));
    num_corr = 0;
    num_lost = 0;
    nbr_of_pages = size(page_info,1);
    for i = 1:nbr_of_pages-1
        current_page = nbr_of_pages - i;
        if(page_info(current_page,type) < round(page_sample_med_in*0.9))
            % corrupted_page
            cursor_in = sum(page_info(1:current_page,type));
            in_interp_temp = linspace(in(cursor_in-1,1),in(cursor_in+1,1),page_sample_med_in - page_info(current_page,type))';
            in = [in(1:cursor_in,:);in_interp_temp;in(cursor_in+1:end,:)];
            page_info(current_page,type) = page_sample_med_in;
            num_corr = num_corr + 1;
        end
        if(page_info(current_page + 1,4) - page_info(current_page,4)> th)
            % lost page
            cursor_in = sum(page_info(1:current_page,type));
            in_interp_temp = linspace(in(cursor_in-1,1),in(cursor_in+1,1),page_sample_med_in)';
            in = [in(1:cursor_in,:);in_interp_temp;in(cursor_in+1:end,:)];
            page_info(current_page,type) = page_info(current_page,type)+page_sample_med_in;
            num_lost = num_lost + 1;
        end
    end
    estimated_end_time = median(diff(page_info(:,4)))*page_info(end,type)/median(page_info(:,type)) + page_info(end,4);
    n = interp_size;
    timeInterp = linspace(1,estimated_end_time,n); % 8
    timeStamp = [page_info(2:end,4); mean(diff(page_info(:,4)))*page_info(end,type)/mean(page_info(:,type))+page_info(end,4)]; %estimate the last timeStamp
    inTime = zeros(1,sum(page_info(:,type)));
    inTimeIndexTemp = cumsum(page_info(:,type));
    inTime(1:inTimeIndexTemp(1)) = linspace(1,timeStamp(1),page_info(1,type));
    average_sample_time = 1000/rate;
    for i = 2:nbr_of_pages
        inTime(inTimeIndexTemp(i-1)+1:inTimeIndexTemp(i)) = linspace(timeStamp(i-1)+average_sample_time,timeStamp(i),page_info(i,type)); %timeStamp(i-1)+average_sample_time:(timeStamp(i) - timeStamp(i-1)-average_sample_time)/page_info(i,1):timeStamp(i);
    end
%     [inTime] = forceMonotonicIncrease(inTime);
    out = interp1(inTime,in,timeInterp);
end
end