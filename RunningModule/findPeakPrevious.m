function [peak,I] = findPeakPrevious(data,ind,ispositive,window)
% find the next negative peak in data from ind
% bool: ispositive (true for positive peak, false for negative peak)
tempPeak = data(ind - 1);
tempI = ind;

if(~ispositive)
    for cursor = ind-1:-1:ind-window
        if(data(cursor)<=tempPeak)
            tempPeak = data(cursor);
            tempI = cursor;
        else
            break;
        end
    end
    peak = tempPeak;
    I = tempI;
else
    for cursor = ind-1:-1:ind-window
        if(data(cursor)>=tempPeak)
            tempPeak = data(cursor);
            tempI = cursor;
        else
            break;
        end
    end
    peak = tempPeak;
    I = tempI;
end
end