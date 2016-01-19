function gamma_correction
clear all;
close all;

X=imread('myRose.jpg');
subplot(241)
image(X);
axis image;
axis off;
X=double(X);

subplot(245);
Xnew=gammac(X,0.5);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 0.5');

subplot(246);
Xnew=gammac(X,1);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 1.0');

subplot(248);
Xnew=gammac(X,1.5);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 1.5');


subplot(247);
Xnew=gammac(X,2);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 2.0');

    function Xnew=gammac(X,val)
        %         Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
        %         Xnew=Xgray.^val;
        RGBmax=255;
        Xnorm = X./RGBmax;
        Xnew=RGBmax.*(Xnorm.^val);
    end


end