% findpeaks customized

function [pks,locs] = findpeaksCustomized(X,Ph,Pd,Np)
X=X';
narginchk(1,11);
%[X,Ph,Pd,Th,Np,Str,infIdx] = parse_inputs(X,varargin{:});
[pks,locs] = getPeaksAboveMinPeakHeight(X,Ph);
%[pks,locs] = removePeaksBelowThreshold(X,pks,locs,Th,infIdx);
[pks,locs] = removePeaksSeparatedByLessThanMinPeakDistance(pks,locs,Pd);
%[pks,locs] = orderPeaks(pks,locs,Str);
[pks,locs] = keepAtMostNpPeaks(pks,locs,Np);
X=X';
%--------------------------------------------------------------------------
% function [X,Ph,Pd,Th,Np,Str,infIdx] = parse_inputs(X,varargin)
% 
% % Validate input signal
% validateattributes(X,{'numeric'},{'nonempty','real','vector'},...
%     'findpeaks','X');
% try
%     % Check the input data type. Single precision is not supported.
%     chkinputdatatype(X);
% catch ME
%     throwAsCaller(ME);
% end
% M = numel(X);
% if (M < 3)
%     error(message('signal:findpeaks:emptyDataSet'));
% end
% 
% %#function dspopts.findpeaks
% hopts = uddpvparse('dspopts.findpeaks',varargin{:});
% Ph  = hopts.MinPeakHeight;
% Pd  = hopts.MinPeakDistance;
% Th  = hopts.Threshold;
% Np  = hopts.NPeaks;
% Str = hopts.SortStr;
% 
% % Validate MinPeakDistance 
% if ~isempty(Pd) && (~isnumeric(Pd) || ~isscalar(Pd) ||any(rem(Pd,1)) || (Pd < 1))
%     error(message('signal:findpeaks:invalidMinPeakDistance', 'MinPeakDistance'));
% end
% 
% % Set default values for MinPeakDistance and NPeaks
% if(isempty(Pd)), Pd = 1; end
% if(isempty(Np)), Np = M; end
% 
% if(Pd >= M)
%     %error(message('signal:findpeaks:largeMinPeakDistance', 'MinPeakDistance', 'MinPeakDistance', num2str( M )));
%     error(message('signal:findpeaks:largeMinPeakDistance', 'MinPeakDistance', 'MinPeakDistance'));
% end
% 
% % Replace Inf by realmax because the diff of two Infs is not a number
% infIdx = isinf(X);
% if any(infIdx),
%     X(infIdx) = sign(X(infIdx))*realmax;
% end
% infIdx = infIdx & X>0; % Keep only track of +Inf

%--------------------------------------------------------------------------
%************* DN MOD *************
% I've made some modifications based on new version of this function
%
% function [pks,locs] = getPeaksAboveMinPeakHeight(X,Ph)
% 
% pks = [];
% locs = [];
% 
% %if all(isnan(X)),
% %    return,
% %end
% 
% Indx = find(X > Ph);
% if(isempty(Indx))
%     %warning(message('signal:findpeaks:largeMinPeakHeight', 'MinPeakHeight', 'MinPeakHeight'));
%     return
% end
% 
% % Peaks cannot be easily solved by comparing the sample values. Instead, we
% % use first order difference information to identify the peak. A peak
% % happens when the trend change from upward to downward, i.e., a peak is
% % where the difference changed from a streak of positives and zeros to
% % negative. This means that for flat peak we'll keep only the rising
% % edge.
% trend = sign(diff(X));
% idx = find(trend==0); % Find flats
% N = length(trend);
% for i=length(idx):-1:1,
%     % Back-propagate trend for flats
%     if trend(min(idx(i)+1,N))>=0,
%         trend(idx(i)) = 1; 
%     else
%         trend(idx(i)) = -1; % Flat peak
%     end
% end
%         
% idx  = find(diff(trend)==-2)+1;  % Get all the peaks
% locs = intersect(Indx,idx);      % Keep peaks above MinPeakHeight
% pks  = X(locs);
%************* DN MOD *************
function [pks,locs] = getPeaksAboveMinPeakHeight(X,Ph)

pks = zeros(0,1);
locs = zeros(0,1);

Indx = find(X > Ph);
if(isempty(Indx))
    Indx=X(1);
    if coder.target('MATLAB')
        warning(message('signal:findpeaks:largeMinPeakHeight', 'MinPeakHeight', 'MinPeakHeight'));
    end
    return
end
    
% Peaks cannot be easily solved by comparing the sample values. Instead, we
% use first order difference information to identify the peak. A peak
% happens when the trend change from upward to downward, i.e., a peak is
% where the difference changed from a streak of positives and zeros to
% negative. This means that for flat peak we'll keep only the rising
% edge.
trend = sign(diff(X));
idx = find(trend==0); % Find flats
N = length(trend);
for i=length(idx):-1:1,
    % Back-propagate trend for flats
    if trend(min(idx(i)+1,N))>=0,
        trend(idx(i)) = 1; 
    else
        trend(idx(i)) = -1; % Flat peak
    end
end

idxp = find(diff(trend)==-2)+1;  % Get all the peaks
if ~isempty(idxp)
    locs = intersect(Indx,idxp(:));      % Keep peaks above MinPeakHeight
    pks  = X(locs);
end

%--------------------------------------------------------------------------
% function [pks,locs] = removePeaksBelowThreshold(X,pks,locs,Th,infIdx)
% 
% idelete = [];
% for i = 1:length(pks),
%     delta = min(pks(i)-X(locs(i)-1),pks(i)-X(locs(i)+1));
%     if delta<Th,
%         idelete = [idelete i]; %#ok<AGROW>
%     end
% end
% if ~isempty(idelete),
%     locs(idelete) = [];
% end
% 
% X(infIdx) = Inf;                 % Restore +Inf
% locs = union(locs,find(infIdx)); % Make sure we find peaks like [realmax Inf realmax]
% pks  = X(locs);

%--------------------------------------------------------------------------
%************* DN MOD *************
% I've made some modifications based on new version of this function
%
% function [pks,locs] = removePeaksSeparatedByLessThanMinPeakDistance(pks,locs,Pd)
% % Start with the larger peaks to make sure we don't accidentally keep a
% % small peak and remove a large peak in its neighborhood. 
% 
% if isempty(pks) || Pd==1,
%     return
% end
% 
% % Order peaks from large to small
% [pks, idx] = sort(pks,'descend');
% locs = locs(idx);
% 
% idelete = ones(size(locs))<0;
% for i = 1:length(locs),
%     if ~idelete(i),
%         % If the peak is not in the neighborhood of a larger peak, find
%         % secondary peaks to eliminate.
%         idelete = idelete | (locs>=locs(i)-Pd)&(locs<=locs(i)+Pd); 
%         idelete(i) = 0; % Keep current peak
%     end
% end
% pks(idelete) = [];
% locs(idelete) = [];
%************* DN MOD *************
function [pks_out,locs_out] = removePeaksSeparatedByLessThanMinPeakDistance(pks,locs,Pd)
% Start with the larger peaks to make sure we don't accidentally keep a
% small peak and remove a large peak in its neighborhood. 

if isempty(pks) || Pd==1,
    pks_out = pks;
    locs_out = locs;
    return
end

% Order peaks from large to small
[pks_temp, idx] = sort(pks,'descend');
locs_temp = locs(idx);

idelete = ones(size(locs_temp))<0;
for i = 1:length(locs_temp),
    if ~idelete(i),
        % If the peak is not in the neighborhood of a larger peak, find
        % secondary peaks to eliminate.
        idelete = idelete | (locs_temp>=locs_temp(i)-Pd)&(locs_temp<=locs_temp(i)+Pd); 
        idelete(i) = 0; % Keep current peak
    end
end
pks_out = pks_temp(~idelete);
locs_out = locs_temp(~idelete);


%--------------------------------------------------------------------------
% function [pks,locs] = orderPeaks(pks,locs,Str)
% 
% if isempty(pks), return; end
% 
% if strcmp(Str,'none')
%     [locs,idx] = sort(locs);
%     pks = pks(idx);
% else
%     [pks,s]  = sort(pks,Str);
%     locs = locs(s);
% end

%--------------------------------------------------------------------------
function [pks_out,locs_out] = keepAtMostNpPeaks(pks,locs,Np)

if length(pks)>Np,
    locs_out = locs(1:Np);
    pks_out  = pks(1:Np);
else
    locs_out = locs;
    pks_out = pks;
end



