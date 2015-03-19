function [ pStar ] = GetWeightedMeanForPoint( v, controlPoints, w )
%GETWEIGHTEDMEANFORPOINT Summary of this function goes here
%   Detailed explanation goes here
    pStar = zeros(1, 2);
    sum_w_i = 0;
    Num = size(controlPoints, 2);
    for i = 1:Num
        pStar = pStar + controlPoints{i} * w(v, i);
        sum_w_i = sum_w_i + w(v, i);
    end

    pStar = pStar * (1.0 / sum_w_i);
end

