%%%���Ժ���-��Ե���
clc
clear
close all

% f=imread('..\data_source\6.jpg');
f=imread('D:\0 �Ϻ���ͨ��ѧ\3d_u\syn_data\tiger\5.512\input_Cam001.png');
fd=im2double(f);
gray=rgb2gray(fd);
figure,
subplot(341),imshow(gray);title('ԭʼ�Ҷ�ͼ��');hold on;


%���̻�ָ�������ӣ���Ruzon���ӱ�Ե���
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
subplot(121),imshow(grayEdg12);title('Ruzon�������ӱ�Ե���');
subplot(122),imshow(bw12);title('Ruzon�������ӱ�Ե����ֵͼ��');



