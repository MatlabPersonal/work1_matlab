function [strideLength, strideLengthVector] = estimateStrideLength(DistanceVector)
    strideLengthVector = diff(DistanceVector);
    % filter strides
    strLenRange = [0.2 1.5];
    strideLengthVector(strideLengthVector<strLenRange(1)) = [];
    strideLengthVector(strideLengthVector>strLenRange(2)) = [];
    strideLength = mean(strideLengthVector);
    
%     figure;
%     plot(strideLengthVector);
end