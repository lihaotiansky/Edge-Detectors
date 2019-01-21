function g=kirsch(f)
%KIRSCH Find edges in gray images with Kirsch operator
%  G=KIRSCH(F) computes the gradient of image F 
%  with 8 3*3 filters:[5 5 5;-3 0 -3;-3 -3 -3], [-3 5 5;-3 0 5;-3 -3 -3]...
if strcmp(class(f),'double')&max(f(:))>1
    f=mat2gray(f);
else % Convert to double, regardless of class(f)
    f=im2double(f);
end

%K0-K7为kirsch的8个方向的模板
K0=[ 5  5  5
    -3  0 -3
    -3 -3 -3];
K1=[-3  5  5
    -3  0  5
    -3 -3 -3];
K2=[-3 -3  5
    -3  0  5
    -3 -3  5];
K3=[-3 -3 -3
    -3  0  5
    -3  5  5];
K4=[-3 -3 -3
    -3  0 -3
     5  5  5];
K5=[-3 -3 -3
     5  0 -3
     5  5 -3];
K6=[ 5 -3 -3
     5  0 -3
     5 -3 -3];
K7=[ 5  5 -3
     5  0 -3
    -3 -3 -3];
%图象上的每个象素都用这8个模板运算后，选择其中最大值作为该象素的边缘强度。
F(:,:,1)=imfilter(f,K0,'conv','replicate','same');
F(:,:,2)=imfilter(f,K1,'conv','replicate','same');
F(:,:,3)=imfilter(f,K2,'conv','replicate','same');
F(:,:,4)=imfilter(f,K3,'conv','replicate','same');
F(:,:,5)=imfilter(f,K4,'conv','replicate','same');
F(:,:,6)=imfilter(f,K5,'conv','replicate','same');
F(:,:,7)=imfilter(f,K6,'conv','replicate','same');
F(:,:,8)=imfilter(f,K7,'conv','replicate','same');
g=max(F,[],3);
g=mat2gray(g);


