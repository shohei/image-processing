function test4
clear all; close all;

X=imread('myRose.jpg');
X=double(X);

subplot(2,3,1);
Y=fliplr(X);
showImage(Y);

subplot(2,3,2);
Y=flipud(X);
showImage(Y);

subplot(2,3,3);
Y=rot90(X);
showImage(Y);

subplot(2,3,4);
Y(:,:,1)=X(:,:,1)';
Y(:,:,2)=X(:,:,2)';
Y(:,:,3)=X(:,:,3)';
showImage(Y);

subplot(2,3,5);
showImage(X);

subplot(2,3,6);
Y = [X X;
     X X];
showImage(Y);



    function showImage(im)
        image(uint8(im));
        axis off;
        axis image;
    end







end