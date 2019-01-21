function g=frei_chen(f,varargin)
%FREI_CHEN Find edges in gray images with Frei_chen operator
%  G=FREI_CHEN(F,INDEX) computes the gradient of image F 
%  with 3*3 filters whose index is in 1D row vector INDEX.

%Verify the correct number of inputs.
error(nargchk(1,3,nargin))

if strcmp(class(f),'double')&max(f(:))>1
    f=mat2gray(f);
else % Convert to double, regardless of class(f)
    f=im2double(f);
end

method=varargin{1};
ind=[];
%K1-K9为Frei-chen的9个模板
%K1-K4为边缘子空间模板
K1=[ 1     sqrt(2)    1
     0        0       0
     -1 (-1)*sqrt(2) -1 ]/(2*sqrt(2));
 
K2=[ 1        0       -1
     sqrt(2)  0   (-1)*sqrt(2)
     1        0       -1 ]/(2*sqrt(2));
 
K3=[ 0       -1    sqrt(2)
     1       0      -1
(-1)*sqrt(2)  1      0 ]/(2*sqrt(2));

K4=[ sqrt(2) -1      0    
     -1       0      1
      0       1   (-1)*sqrt(2) ]/(2*sqrt(2));
%K5-K8为直线子空间模板 
K5=[ -1   0   1
      0   0   0
      1   0   -1]/2;
K6=[  0   1   0
     -1   0  -1
      1   1   0 ]/2; 
  
K7=[ -2   1  -2
      1   4   1
     -2   1  -2]/6;
 
K8=[  1  -2   1
     -2   4  -2
      1  -2   1]/6;
%K9为平均子空间模板  
K9=[  1   1   1
      1   1   1
      1   1   1]/3;
  
% %Frei&chen的4个模板 
% K1=[ 2  3  4
%      0  0  0
%     -2 -3 -2];
% K2=[ 2  0 -2
%      0 -2  3
%      3 -2  0];
% K3=[ 3  0 -3
%      2  0 -2
%     -2  0  2];
% K4=[ 2  0 -2
%     -3  2  0
%      0  2 -3];
%图象上的每个象素都用选中的模板运算后，取其平方和为该象素的边缘强度。
F(:,:,1)=imfilter(f,K1,'conv','replicate','same');
F(:,:,2)=imfilter(f,K2,'conv','replicate','same');
F(:,:,3)=imfilter(f,K3,'conv','replicate','same');
F(:,:,4)=imfilter(f,K4,'conv','replicate','same');
F(:,:,5)=imfilter(f,K5,'conv','replicate','same');
F(:,:,6)=imfilter(f,K6,'conv','replicate','same');
F(:,:,7)=imfilter(f,K7,'conv','replicate','same');
F(:,:,8)=imfilter(f,K8,'conv','replicate','same');
F(:,:,9)=imfilter(f,K9,'conv','replicate','same');

%Perform the detection specified
switch method  
    case 'edge'
        g=sum(F(:,:,1:4).^2,3);
    case 'strailine'
        g=sum(F(:,:,5:8).^2,3);
    case 'all'
        g=sum(F.^2,3);
    case 'any'
        if length(varargin)==1
            error('No input the index of operator')
        else        
            ind=varargin{2};
            if(max(size(ind)>9)||max(max(ind))>9)
                error('The third input is omitted')
            elseif(max(size(ind)<1)||min(min(ind))<1)
                error('The third input cannot be less than 1')
            else            
                g=sum(F(:,:,ind).^2,3);
            end
        end
    otherwise
        error('Unknow method')
end
g=mat2gray(g);