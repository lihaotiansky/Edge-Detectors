function hist1=CreateWedgeHistograms(f, mask, r, c, radius, nwedges)
intensity=f;
global MAXCLUSTERS;
nQuadrant=4;
bin=struct('wsum',0,'weight',0,'value',0);
hist=repmat(bin,[nwedges*nQuadrant,MAXCLUSTERS]);
for k = 1:nwedges 
    for i = 0:radius-1
        for j =0:radius-1            
%             if (mask(i+1,j+1,k)> 0) 
                [hist0,min_index]=AddWeight(intensity, mask(i+1,j+1,k), r-radius+j, c+i);
                hist(k,min_index)=hist0;
                [hist0,min_index]=AddWeight(intensity, mask(i+1,j+1,k), r-i-1, c-radius+j);
                hist(k+nwedges,min_index)=hist0;
                [hist0,min_index]=AddWeight(intensity, mask(i+1,j+1,k), r+radius-j-1, c-i-1);
                hist(k+2*nwedges,min_index)=hist0;
                [hist0,min_index]=AddWeight(intensity, mask(i+1,j+1,k), r+i, c+radius-j-1);
                hist(k+3*nwedges,min_index)=hist0;            
%             end
        end
    end
end
hist1=hist;

function [hist0,min_index]=AddWeight(intensity, weight, r, c)
global MAXCLUSTERS;
MAXBRIGHTNESS=255;
hist0=struct('wsum',0,'weight',0,'value',0);
min_index = floor(intensity(r,c) * (MAXCLUSTERS - 1) / MAXBRIGHTNESS)+1;
hist0.weight =weight;
hist0.wsum =weight * intensity(r,c);
