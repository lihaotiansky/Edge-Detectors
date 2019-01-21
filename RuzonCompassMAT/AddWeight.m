function [hist0,min_index]=AddWeight(intensity, weight, r, c)
global MAXCLUSTERS;
MAXBRIGHTNESS=255;
hist0=struct('wsum',0,'weight',0,'value',0);
min_index = floor(intensity(r,c) * (MAXCLUSTERS - 1) / MAXBRIGHTNESS)+1;
hist0.weight =weight;
hist0.wsum =weight * intensity(r,c);
