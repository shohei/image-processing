function gamma_correction
clear all;
close all;

X=imread('myRose.jpg');
subplot(341)
image(X);
axis image;
axis off;
X=double(X);

subplot(345);
Xnew=gammac(X,0.5);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 0.5');
subplot(349);
hist(Xnew,[0:255]);
% c=std(Xnew)/mean(Xnew);
% cstr=sprintf('Contrast=%3.2f ',c);
% title(cstr);

subplot(346);
Xnew=gammac(X,1);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 1.0');
subplot(3,4,10);
hist(Xnew,[0:255]);
% c=std(Xnew)/mean(Xnew);
% cstr=sprintf('Contrast=%3.2f ',c);
% title(cstr);


subplot(348);
Xnew=gammac(X,1.5);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 1.5');
subplot(3,4,11);
hist(Xnew,[0:255]);
% c=std(Xnew)/mean(Xnew);
% cstr=sprintf('Contrast=%3.2f ',c);
% title(cstr);


subplot(347);
Xnew=gammac(X,2);
imagesc(uint8(Xnew));
axis image;
axis off;
title('gamma 2.0');
subplot(3,4,12);
hist(Xnew,[0:255]);
% c=std(Xnew)/mean(Xnew);
% cstr=sprintf('Contrast=%3.2f ',c);
% title(cstr);





    function Xnew=gammac(X,val)
        %         Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
        %         Xnew=Xgray.^val;
        RGBmax=255;
        Xnorm = X./RGBmax;
        Xnew=RGBmax.*(Xnorm.^val);
    end


end