function g=direcedge(f)
%DIRECEDGE Find edges in gray images with GAUSSIAN operator including
%directional information.Get the statistical direction using Kirsch 
%operator, that is edge direction.

if strcmp(class(f),'double')&max(f(:))>1
    f=mat2gray(f);
else % Convert to double, regardless of class(f)
    f=im2double(f);
end
% %对原图进行高斯滤波平滑
% w=fspecial('gaussian',3,0.5);
% f=mat2gray(imfilter(f,w,'conv','replicate'));
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

%得到图像中每个像素的梯度方向
[G,D]=max(F,[],3);
direchist=zeros(1,8);
for i=1:size(D,1)   %统计梯度方向
    for j=1:size(D,2)
        t=D(i,j);
        direchist(t)=direchist(t)+1;
    end
end
[PK,direcInd]=findpeaks(direchist);
% figure,
% plot(direchist),hold on;
% plot(direcInd,direchist(direcInd),'ro');
%获取统计方向的极值点，取最大两个极值点
[Y,I]=sort(PK,2,'descend');
theta=direcInd(I);

%高斯函数一阶导数，水平模板为gaus1,垂直模板为gaus2
%高斯算子与Kirsch算子相结合
gaus1=[5 0 -5
       7 0 -7
       5 0 -5];
gaus2=[5 7 5
       0 0 0
      -5 -7 -5];
pi=3.14;

if(numel(theta)>1)
    %通过边缘方向确定方向边缘检测算子
    gausTheta1=cos((theta(1)-1)*pi/4)*gaus1+sin((theta(1)-1)*pi/4)*gaus2;
    gausTheta2=cos((theta(2)-1)*pi/4)*gaus1+sin((theta(2)-1)*pi/4)*gaus2;

    %将两个方向检测结果或运算
    g1=imfilter(f,gausTheta1,'conv','replicate','same');
    g2=imfilter(f,gausTheta2,'conv','replicate','same');
    % figure,
    % subplot(121),imshow(g1);
    % subplot(122),imshow(g2);

    %OTSU阈值分割
    g1=mat2gray(g1);
    g2=mat2gray(g2);
    gbw1=im2bw(g1,graythresh(g1));
    gbw2=im2bw(g1,graythresh(g2));
    %骨骼化，细化
    gbw1=bwmorph(gbw1,'skel',Inf);
    gbw1=bwmorph(gbw1,'thin',Inf);
    gbw2=bwmorph(gbw2,'skel',Inf);
    gbw2=bwmorph(gbw2,'thin',Inf);
    % figure,
    % subplot(121),imshow(gbw1);
    % subplot(122),imshow(gbw2);
    g=gbw1|gbw2;
    % figure,imshow(g);
else
    %通过边缘方向确定方向边缘检测算子
    gausTheta1=cos((theta(1)-1)*pi/4)*gaus1+sin((theta(1)-1)*pi/4)*gaus2;
    g1=imfilter(f,gausTheta1,'conv','replicate','same');
    %OTSU阈值分割
    g1=mat2gray(g1);  
    gbw1=im2bw(g1,graythresh(g1));
    %骨骼化，细化
    gbw1=bwmorph(gbw1,'skel',Inf);
    gbw1=bwmorph(gbw1,'thin',Inf);
    g=gbw1;
end






