function [acc_vec] = getAccVector(acc)
acc_vec = sqrt(acc(:,1).^2 + acc(:,2).^2 + acc(:,3).^2);
end