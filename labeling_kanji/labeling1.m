function labeling1
clear all; close all;

X=imread('yuu.png');
subplot(221);
imagesc(X);
axis image;
axis off;
title('raw');

X=double(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
Xgray = 255*(Xgray>120) + 0*(Xgray<=120);
unique(Xgray);

subplot(222);
imagesc(uint8(Xgray));
colormap(gray);
axis image;
axis off;
title('gray scale');

F = 1/9*[1 1 1;1 1 1;1 1 1];
[m,n] = size(Xgray);
for xidx=2:m-1
  for yidx=2:m-1
      Xgray2(xidx-1:xidx+1,yidx-1:yidx+1) = Xgray(xidx-1:xidx+1,yidx-1:yidx+1)*F;
  end
end
subplot(223);
imagesc(uint8(Xgray2));
colormap(gray);
axis image;
axis off;
title('moving average');


F2 = [0.25 0.5 0.25];
F3 = [0.25;
      0.5;
      0.5];
for xidx=2:m-1
  for yidx=2:m-1
      Xgray3(xidx-1:xidx+1,yidx-1:yidx+1) = F2*Xgray(xidx-1:xidx+1,yidx-1:yidx+1)*F3;
  end
end
subplot(224);
imagesc(uint8(Xgray3));
colormap(gray);
axis image;
axis off;
title('gaussian filter');

end