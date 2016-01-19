function labeling1
clear all; close all;

X=imread('yuu.png');
X=double(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
Xgray = 255*(Xgray>120) + 0*(Xgray<=120);
unique(Xgray)
imagesc(uint8(Xgray));
colormap(gray);
axis image;
axis off;











end