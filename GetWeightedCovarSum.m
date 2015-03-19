function [ mean ] = GetWeightedCovarSum( pHat, w )
%GETWEIGHTEDCOVARSUM Summary of this function goes here
%   Detailed explanation goes here
mean = 0;
N = size(pHat, 2);
for i = 1:N
    prod = pHat{i} * pHat{i}';
    mean = mean + prod * w(i);
end

end

