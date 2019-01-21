%%%���Ժ���-��Ե���
clc
clear
close all

% f=imread('..\data_source\6.jpg');
f=imread('epi1.png');
fd=im2double(f);
gray=rgb2gray(fd);
figure,
subplot(341),imshow(gray);title('ԭʼ�Ҷ�ͼ��');hold on;

%%%Sobel��Ե�����
grayEdg1=edge(gray,'sobel',[],'both');
subplot(342),imshow(grayEdg1);title('sobel���');hold on;

%%%Prewitt��Ե�����
grayEdg2=edge(gray,'prewitt',[],'both');
subplot(343),imshow(grayEdg2);title('prewitt���');hold on;

%%%Roberts��Ե�����
grayEdg3=edge(gray,'roberts',[],'both');
subplot(344),imshow(grayEdg3);title('roberts���');hold on;

%%%LoG��Ե�����
grayEdg4=edge(gray,'log',0.003,2);
subplot(345),imshow(grayEdg4);title('LoG���');hold on;

%%%Canny��Ե�����
grayEdg5=edge(gray,'canny',[0.4 0.5],1.5);
subplot(346),imshow(grayEdg5);title('canny���');hold on;

%%%Kirsch��Ե�����
grayEdg6=kirsch(gray);
bw6=im2bw(grayEdg6,graythresh(grayEdg6));
% subplot(347),imshow(grayEdg6);title('kirsch���');hold on;
subplot(347),imshow(bw6);title('kirsch���');hold on;

%%%Frei-chen��Ե�����
grayEdg7=frei_chen(gray,'edge');
bw7=im2bw(grayEdg7,graythresh(grayEdg7));
% subplot(348),imshow(grayEdg7);title('Frei-chen���');hold on;
subplot(348),imshow(bw7);title('Frei-chen���');hold on;

%�����Ե�������
grayEdg8=direcedge(gray);
subplot(349),imshow(grayEdg8);title('�����Ե���');hold on;

%��������֮8����Prewitt���ӱ�Ե���
grayEdg9=PrewittCompass(gray);
bw9=im2bw(grayEdg9,graythresh(grayEdg9));
% subplot(3,4,10),imshow(grayEdg9);title('��������֮8����Prewitt��Ե���');hold on;
subplot(3,4,10),imshow(bw9);title('��������֮8����Prewitt��Ե���');hold on;

%��������֮Robinson���ӱ�Ե���,��8����Sobel����
grayEdg10=RobinsonCompass(gray);
bw10=im2bw(grayEdg10,graythresh(grayEdg10));
% subplot(3,4,11),imshow(grayEdg10);title('��������֮Robinson��Ե���');hold on;
subplot(3,4,11),imshow(bw10);title('��������֮Robinson��Ե���');hold on;

%��������֮�߼��
grayEdg11=LinedetecCompass(gray);
bw11=im2bw(grayEdg11,graythresh(grayEdg11));
% subplot(3,4,12),imshow(grayEdg10);title('��������֮�߼��');hold on;
subplot(3,4,12),imshow(bw11);title('��������֮�߼��');hold on;

[H, theta, rho]= hough(f,'RhoResolution', 0.5);    

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



