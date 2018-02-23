function [xlRange,xlRange2]=Write2SpreadSheet(i,movementType,sheet,filename,Data1,Data2)
row=i+1;
if(movementType==3)
    xlRange = strcat('E',num2str(row));
    xlswrite(filename,Data1,sheet,xlRange);
    xlRange2 = strcat('F',num2str(row));
    xlswrite(filename,Data2,sheet,xlRange2);
elseif(movementType==4)
    xlRange = strcat('I',num2str(row));
    xlswrite(filename,Data1,sheet,xlRange);
    xlRange2='N/A';
end
    
end