function [error,error_max] = getPercentageError(x,y,bool)
    error = sum(abs(y-x)./max(x,y))*100/length(x);
    error_max = max(abs(y-x)./max(x,y))*100;
    if(bool)
        figure;
        err_array = (abs(y-x)./y)*100;
        ind = find(err_array>5);
        plot(err_array); hold on;
        plot(ind,err_array(ind),'r.');
        title('error distribution');
        legend('error','>5%');
    end
end