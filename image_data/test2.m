function test2

clear all; close all;

X=imread('myRose.jpg');
figure(1);
image(X);
axis image;
axis off;

Xred=double(X(:,:,1));
Xgreen=double(X(:,:,2));
Xblue=double(X(:,:,3));

Xgray=(Xred+Xgreen+Xblue)/3;
figure(2);
imagesc(Xgray);
colormap(gray);
axis image;
axis off;

figure(3);
image(uint8(Xgray));
colormap(gray);
axis image;
axis off;

figure(4);
image(X);
colormap(gray);
axis image;
axis off;



Xgray=uint8(Xgray);
imwrite(Xgray,'RoseGray01.jpg');


end