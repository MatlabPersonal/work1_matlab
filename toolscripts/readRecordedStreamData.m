function [sensorData] = readRecordedStreamData(file)
% get raw data from sensor streamed data and recorded on dev app
% note the scale is set to 4/250 by default, please adjust accordingly
rawdata = load(file);
sensorData.accCal = rawdata(:,[2 3 4])/8192*4;
sensorData.gyroCal = rawdata(:,[5 6 7])*0.00762939453125*8;
sensorData.magCal = rawdata(:,[8 9 10]);
sensorData.timeInterp = processCounter(rawdata(:,11))';


    function t = processCounter(counter)
        len = length(counter);
        k=1;
        index_array = [];
        for i=1:len
            if(counter(i) == 32767)
                index_array(k)=i;
                k=k+1;
            end
        end
        if(isempty(index_array))
        else
            len2 = length(index_array);
            if len2 == 0
            else
                for l=1:len2
                    counter(index_array(l)+1:end) = counter(index_array(l)+1:end)+65536;
                end
            end
        end
        
        t = counter;
        t = (t-t(1))./100;
    end
end