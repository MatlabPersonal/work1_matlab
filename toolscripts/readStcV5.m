function [Stc] = readStcV5(filename)
%--------------------------------------------------------------------------
% Try finding Stc from saved V5 sensor csv file
% tested with below file
% filename = 'D:\Derek\Matlab\temprunning\MatlabFiles\data\cad_bug\f400bdee-b0dc-4421-a6e3-1f68990b53fd.csv';
%--------------------------------------------------------------------------
[~,TXT,~] = xlsread(filename);
StcRowIdx = 0;
for i = 1:size(TXT,2)
    if(strcmp(TXT{1,i},'Stc'))
        StcRowIdx = i;
        break;
    end
end
if StcRowIdx == 0
    error('(????)????? [error] no Stc column found in file');
end
StcTxT = TXT(2:end,StcRowIdx);
formatIn = 'HH:MM:SS:FFF';
Stc = zeros(length(StcTxT),1);
for i = 1:length(StcTxT)
    if(~isempty(StcTxT{i,1}))
        Stc(i) = datenum(StcTxT{i,1},formatIn);
    else
        Stc(i) = NaN;
    end
end
ind = find(isnan(Stc));
for i = 1:length(ind)
    Stc(ind(i)) = (Stc(ind(i)-1) + Stc(ind(i)+1))/2;
end
Stc = (Stc - Stc(1))*1e8;
end
