function g=RobinsonCompass(f)
%ROBINSONCOMPASS Find edges in gray images with set of 8 kernels is produced
%by taking sobel operator and rotating its coefficients circularly
%Get the maximum response |G| for each pixel that is output magnitude image.
if strcmp(class(f),'double')&max(f(:))>1
    f=mat2gray(f);
else % Convert to double, regardless of class(f)
    f=im2double(f);
end
h=fspecial('sobel');
h=h';
for k=1:8    
    s(:,:,k)=h;    
    h=imrotate(h,45,'crop');
end

%图象上的每个象素都用这8个模板运算后，选择其中最大值作为该象素的边缘强度。
F(:,:,1)=imfilter(f,s(:,:,1),'conv','replicate','same');
F(:,:,2)=imfilter(f,s(:,:,2),'conv','replicate','same');
F(:,:,3)=imfilter(f,s(:,:,3),'conv','replicate','same');
F(:,:,4)=imfilter(f,s(:,:,4),'conv','replicate','same');
F(:,:,5)=imfilter(f,s(:,:,5),'conv','replicate','same');
F(:,:,6)=imfilter(f,s(:,:,6),'conv','replicate','same');
F(:,:,7)=imfilter(f,s(:,:,7),'conv','replicate','same');
F(:,:,8)=imfilter(f,s(:,:,8),'conv','replicate','same');
g=max(F,[],3);
g=mat2gray(g);