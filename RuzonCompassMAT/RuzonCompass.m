function ImgOut=RuzonCompass(ImgIn,sigma,radius,space,angles,nWedges)
%RUZONCOMPASS find edges in gray images with rotated Ruzon compass
%operator, corresponding to staticetic the gray distribution of two semi-circle
%at the two sides of specified orientation diameter.Determine the direction 
%through the max EMD between two distribution. The max EMD is the strength
%at the orientation.
f=ImgIn;
if(size(ImgIn,3)~=1)
    error('Input image must be gray image');
end
if strcmp(class(f),'double')& max(f(:))>1
    f=mat2gray(f)*255;
else % Convert to double, regardless of class(f)
    f=im2double(f)*255;
end

global MAXCLUSTERS;
MAXCLUSTERS=51;
masksz=ceil(3*sigma);
maxradius=radius;
[subimgrows,subimgcols]=size(f);
WEDGEWT=1.0;
dimensions(1) = radius;
dimensions(2) = radius;
dimensions(3) = subimgrows - radius;
dimensions(4) = subimgcols - radius;

bin=struct('wsum',0,'weight',0,'value',0);
hist=repmat(bin,[nWedges*4,MAXCLUSTERS]);
hist1=repmat(bin,[1,MAXCLUSTERS]);
hist2=repmat(bin,[1,MAXCLUSTERS]);
hist1norm=repmat(bin,[1,MAXCLUSTERS]);
hist2norm=repmat(bin,[1,MAXCLUSTERS]);

work=zeros(1,4 * nWedges);
	
%Allocate output arguments
% orientation= zeros(dimensions(3) - dimensions(1) + 1, dimensions(4)- dimensions(2) + 1);
strength= zeros(dimensions(3) - dimensions(1) + 1, dimensions(4)- dimensions(2) + 1);
%构建一个象限内n个wedge的masksz*maskzs大小的mask
[mask,masksum]=CreateMask(sigma,nWedges,masksz);

% maxwt=0.0;
sum=0.0;
for i = 1:masksz * masksz
    sum = sum +masksum(i);
%     if (masksum(i) > maxwt)
%         maxwt = masksum(i);
%     end
end
sum = sum /nWedges;  

%Loop over every desired image position
for r = maxradius+1:space:subimgrows - maxradius+1
    for c = maxradius+1:space:subimgcols - maxradius+1
       hist=CreateWedgeHistograms(f, mask, r, c, masksz, nWedges);       
       %Compute desired data and cell pointers for each angle
       anglewedges = angles * nWedges / 90.0;
       if(anglewedges <= 2)
           inmass = sum *anglewedges * WEDGEWT;
       else
           inmass = sum *(WEDGEWT * 2 + anglewedges - 2);
       end
       outmass = sum * (WEDGEWT * 2 + 4 * nWedges - anglewedges - 2);
       nori =2 * nWedges;
       outputrows = size(strength,1);
       outputcols = size(strength,2);
       % Compute initial histogram sums 
       for i = 1: MAXCLUSTERS
           hist1(i).weight = 0.0;
           hist1(i).wsum = 0.0;
           for j =1:anglewedges
               if (j == 1 || j == anglewedges) 
                   hist1(i).weight = hist1(i).weight+ hist(j,i).weight * WEDGEWT;
                   hist1(i).wsum = hist1(i).wsum+hist(j,i).wsum * WEDGEWT;
               else
                   hist1(i).weight =hist1(i).weight + hist(j,i).weight;
                   hist1(i).wsum =hist1(i).wsum + hist(j,i).wsum;
               end
           end
           hist2(i).weight = 0.0;
           hist2(i).wsum = 0.0;
           for j = anglewedges+1:4 * nWedges
               if (j == anglewedges+1 || j == 4 * nWedges)
                   hist2(i).weight=hist2(i).weight + hist(j,i).weight * WEDGEWT;
                   hist2(i).wsum=hist2(i).wsum + hist(j,i).wsum * WEDGEWT;
               else
                   hist2(i).weight = hist2(i).weight+hist(j,i).weight;
                   hist2(i).wsum = hist2(i).wsum+hist(j,i).wsum; 
               end
           end
       end     
	    
	  %Loop over every orientation
	  for i =1:nori
	    %Normalize the histograms 
        for j = 1:MAXCLUSTERS
            hist1norm(j).value = hist1(j).wsum / hist1(j).weight;
            hist1norm(j).weight = hist1(j).weight / inmass;
            hist2norm(j).value = hist2(j).wsum / hist2(j).weight;
            PARTIAL_MATCH=1;
	      if (PARTIAL_MATCH) %Normalize both by same amount
              hist2norm(j).weight = hist2(j).weight / inmass;
          else %Normalize both by the number of wedges 
              hist2norm(j).weight = hist2(j).weight / outmass;
          end
        end             
          % Compute EMD
          work(i) = GrayEMD(hist1norm, hist2norm);
          temp=work(i);         
          %disp(['rows:',num2str(r),'  clos:',num2str(c),'  Ori:',num2str(i),'  EMD:',num2str(temp)])
          if (work(i) > 1)
              work(i) = 1.0;
          else if (work(i) < 0)
                  work(i) = 0.0;
              end
          end
%           str((r - maxradius) / space,(c-maxradius) / space *...
%              outputrows,i) = work(i);
         % Update the histograms except for the last iteration
         if (i < nori )
             for j =1:MAXCLUSTERS
                 hist1(j).weight =hist1(j).weight -hist(i,j).weight * WEDGEWT... 
                      +hist(mod(i+anglewedges,4*nWedges),j).weight *WEDGEWT;
%             -hist(mod(i+1,4*nWedges),j).weight *(1 - WEDGEWT)...
%               +hist(mod(i+anglewedges-1,4*nWedges),j).weight * (1 - WEDGEWT);


              hist1(j).wsum =hist1(j).wsum -hist(i,j).wsum * WEDGEWT... 
                  +hist(mod(i+anglewedges,4*nWedges),j).wsum *WEDGEWT;
%               -hist(mod(i+1,4*nWedges),j).wsum *(1 - WEDGEWT)...              
%               +hist(mod(i+anglewedges-1,4*nWedges),j).wsum * (1 - WEDGEWT);

              hist2(j).weight = hist2(j).weight... 
              -hist(mod(i+anglewedges,4*nWedges),j).weight * WEDGEWT...
              +hist(i,j).weight * WEDGEWT;
%           -hist(mod(i+anglewedges+1,4*nWedges),j).weight*(1 -WEDGEWT)...              
%            +hist(mod(i+4*nWedges-1,4*nWedges),j).weight*(1 - WEDGEWT);

              hist2(j).wsum = hist2(j).wsum... 
              -hist(mod(i+anglewedges,4*nWedges),j).wsum * WEDGEWT...
              +hist(i,j).wsum * WEDGEWT;
%               -hist(mod(i+anglewedges+1,4*nWedges),j).wsum*(1 - WEDGEWT)...               
%               +hist(mod(i+4*nWedges-1,4*nWedges),j).wsum*(1 - WEDGEWT);

             end
         end
      end
	  strength((r - maxradius) / space,(c - maxradius) / space)=ComputeOutputParameters(work, nWedges, nori);                  
    end
end
ImgOut=strength;