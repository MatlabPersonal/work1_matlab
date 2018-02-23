function [accNorm] = normaliseAcc(acc)
accNorm = zeros(length(acc(:,1)),3);
for i = 1:3
    accNorm(:,i) = acc(:,i)./sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
end
end