function ycbcr_test
close all; clear;

%% lena
im = imread('lena.jpg');
[X,Y,c] = size(im);
Ys= zeros(X,Y);
Cbs= zeros(X,Y);
Crs = zeros(X,Y);
for y=1:Y
    for x=1:X
        R = im(y,x,1);
        G = im(y,x,1);
        B = im(y,x,1);
        [Y,Cb,Cr] = RGB2YCbCR(R,G,B);
        Ys(y,x) = Y;
        Cbs(y,x) = Cb;
        Crs(y,x) = Cr;        
    end
end
subplot(241);
imshow(im);
title('original');
subplot(242);
imagesc(Ys);
colormap(gray);
axis off;
axis image;
title('Luminance');
subplot(243);
imagesc(Cbs);colormap(gray);
title('Color diff(Blue)');
axis off;
axis image;
subplot(244);
imagesc(Crs);colormap(gray);
title('Color diff(Red)');
axis off;
axis image;

%% cherry
im = imread('cherry.jpg');
[X,Y,c] = size(im);
Ys= zeros(X,Y);
Cbs= zeros(X,Y);
Crs = zeros(X,Y);
for y=1:Y
    for x=1:X
        R = im(y,x,1);
        G = im(y,x,1);
        B = im(y,x,1);
        [Y,Cb,Cr] = RGB2YCbCR(R,G,B);
        Ys(y,x) = Y;
        Cbs(y,x) = Cb;
        Crs(y,x) = Cr;        
    end
end
subplot(245);
imshow(im);
title('original');
subplot(246);
imagesc(Ys);
colormap(gray);
axis off;
axis image;
title('Luminance');
subplot(247);
imagesc(Cbs);colormap(gray);
axis off;
axis image;
title('Color diff(Blue)');
subplot(248);
imagesc(Crs);colormap(gray);
title('Color diff(Red)');
axis off;
axis image;


    function [Y,Cb,Cr] = RGB2YCbCR(R,G,B)       
        Y = 0.299 * R + 0.587 * G + 0.114 * B - 128;
        Cb = - 0.1687 * R - 0.3313 * G + 0.5 * B + 128;
        Cr = 0.5 * R - 0.4187 * G - 0.0813 * B + 128;
    end

end