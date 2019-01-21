%%%测试函数-边缘检测
clc
clear
close all

% f=imread('..\data_source\6.jpg');
f=imread('D:\0 上海交通大学\3d_u\syn_data\tiger\5.512\input_Cam001.png');
fd=im2double(f);
gray=rgb2gray(fd);
figure,
subplot(341),imshow(gray);title('原始灰度图像');hold on;


%罗盘或指南针算子，即Ruzon算子边缘检测
sigma=1;
radius=ceil(3*sigma);
space=1;
angles=180;
nWedges=6;
grayEdg12=RuzonCompass(gray,sigma,radius,space,angles,nWedges);
% load grayEdge12.mat
grayEdg12=mat2gray(grayEdg12);
bw12=im2bw(grayEdg12,graythresh(grayEdg12));
figure,
subplot(121),imshow(grayEdg12);title('Ruzon罗盘算子边缘检测');
subplot(122),imshow(bw12);title('Ruzon罗盘算子边缘检测二值图像');



