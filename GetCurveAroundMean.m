function [ pHat ] = GetCurveAroundMean( p, pStar )
%GETCURVEAROUNDMEAN Summary of this function goes here
%   Detailed explanation goes here
N = size(p, 2);
pHat = {};
for i = 1:N
    pHat{i} = p{i} - pStar;
end

end

