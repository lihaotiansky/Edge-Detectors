%%%²âÊÔº¯Êı-±ßÔµ¼ì²â
clc
clear
close all

% f=imread('..\data_source\6.jpg');
f=imread('epi1.png');
fd=im2double(f);
gray=rgb2gray(fd);
figure,
subplot(341),imshow(gray);title('Ô­Ê¼»Ò¶ÈÍ¼Ïñ');hold on;

%%%Sobel±ßÔµ¼ì²âÆ÷
grayEdg1=edge(gray,'sobel',[],'both');
subplot(342),imshow(grayEdg1);title('sobel¼ì²â');hold on;

%%%Prewitt±ßÔµ¼ì²âÆ÷
grayEdg2=edge(gray,'prewitt',[],'both');
subplot(343),imshow(grayEdg2);title('prewitt¼ì²â');hold on;

%%%Roberts±ßÔµ¼ì²âÆ÷
grayEdg3=edge(gray,'roberts',[],'both');
subplot(344),imshow(grayEdg3);title('roberts¼ì²â');hold on;

%%%LoG±ßÔµ¼ì²âÆ÷
grayEdg4=edge(gray,'log',0.003,2);
subplot(345),imshow(grayEdg4);title('LoG¼ì²â');hold on;

%%%Canny±ßÔµ¼ì²âÆ÷
grayEdg5=edge(gray,'canny',[0.4 0.5],1.5);
subplot(346),imshow(grayEdg5);title('canny¼ì²â');hold on;

%%%Kirsch±ßÔµ¼ì²âÆ÷
grayEdg6=kirsch(gray);
bw6=im2bw(grayEdg6,graythresh(grayEdg6));
% subplot(347),imshow(grayEdg6);title('kirsch¼ì²â');hold on;
subplot(347),imshow(bw6);title('kirsch¼ì²â');hold on;

%%%Frei-chen±ßÔµ¼ì²âÆ÷
grayEdg7=frei_chen(gray,'edge');
bw7=im2bw(grayEdg7,graythresh(grayEdg7));
% subplot(348),imshow(grayEdg7);title('Frei-chen¼ì²â');hold on;
subplot(348),imshow(bw7);title('Frei-chen¼ì²â');hold on;

%·½Ïò±ßÔµ¼ì²âËã×Ó
grayEdg8=direcedge(gray);
subplot(349),imshow(grayEdg8);title('·½Ïò±ßÔµ¼ì²â');hold on;

%ÂŞÅÌËã×ÓÖ®8·½ÏòPrewittËã×Ó±ßÔµ¼ì²â
grayEdg9=PrewittCompass(gray);
bw9=im2bw(grayEdg9,graythresh(grayEdg9));
% subplot(3,4,10),imshow(grayEdg9);title('ÂŞÅÌËã×ÓÖ®8·½ÏòPrewitt±ßÔµ¼ì²â');hold on;
subplot(3,4,10),imshow(bw9);title('ÂŞÅÌËã×ÓÖ®8·½ÏòPrewitt±ßÔµ¼ì²â');hold on;

%ÂŞÅÌËã×ÓÖ®RobinsonËã×Ó±ßÔµ¼ì²â,¼´8·½ÏòSobelËã×Ó
grayEdg10=RobinsonCompass(gray);
bw10=im2bw(grayEdg10,graythresh(grayEdg10));
% subplot(3,4,11),imshow(grayEdg10);title('ÂŞÅÌËã×ÓÖ®Robinson±ßÔµ¼ì²â');hold on;
subplot(3,4,11),imshow(bw10);title('ÂŞÅÌËã×ÓÖ®Robinson±ßÔµ¼ì²â');hold on;

%ÂŞÅÌËã×ÓÖ®Ïß¼ì²â
grayEdg11=LinedetecCompass(gray);
bw11=im2bw(grayEdg11,graythresh(grayEdg11));
% subplot(3,4,12),imshow(grayEdg10);title('ÂŞÅÌËã×ÓÖ®Ïß¼ì²â');hold on;
subplot(3,4,12),imshow(bw11);title('ÂŞÅÌËã×ÓÖ®Ïß¼ì²â');hold on;

[H, theta, rho]= hough(f,'RhoResolution', 0.5);    

%ÂŞÅÌ»òÖ¸ÄÏÕëËã×Ó£¬¼´RuzonËã×Ó±ßÔµ¼ì²â
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
subplot(121),imshow(grayEdg12);title('RuzonÂŞÅÌËã×Ó±ßÔµ¼ì²â');
subplot(122),imshow(bw12);title('RuzonÂŞÅÌËã×Ó±ßÔµ¼ì²â¶şÖµÍ¼Ïñ');



