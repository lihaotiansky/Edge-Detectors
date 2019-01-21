function [mask,masksum]=CreateMask(sigma,nWedges,masksz)
%Create the weight mask composed of pixels' area in circle and distance to
%the center
gauss=zeros(masksz,masksz);
R=masksz;
% nPoints=0;
for i=1:R
    for j=1:R
        r=sqrt((R-(i-1)-0.5)^2+((j-1)+0.5)^2);
        gauss(i,j)=r*exp(-(r^2)/(2*sigma^2));        
    end
end

PAmask=CreatePAreaMask(sigma*3,nWedges);
for j=1:nWedges
    mask(:,:,j)=gauss.*PAmask(:,:,j);
end
masksum=sum(mask,3);  
% for i=1:masksz
%     for j=1:masksz
%         if(masksum(i,j)>0)
%             nPoints=nPoints+1;
%         end
%     end
% end
% nPoints=4*nPoints;
            