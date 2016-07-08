function labeling2
clear all; close all;

X=imread('yuu.png');
X=double(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
Xgray = 1*(Xgray>120) + 0*(Xgray<=120);

% [m,n] = size(X);
% F2 = [0.25 0.5 0.25];
% F3 = [0.25;
%       0.5;
%       0.5];
% for xidx=2:m-1
%   for yidx=2:m-1
%       Xgray2(xidx-1:xidx+1,yidx-1:yidx+1) = F2*Xgray(xidx-1:xidx+1,yidx-1:yidx+1)*F3;
%   end
% end
% subplot(121);
% imagesc(uint8(Xgray2));
% colormap(gray);
% axis image;
% axis off;
% title('gaussian filtered');

x=Xgray;
% x=Xgray2;
x=(x-min(x(:)))/(max(x(:))-min(x(:)));
[M,N]=size(x);
x(1,:)=0;
x(M,:)=0;
x(:,1)=0;
x(:,N)=0;
label=20;
for m=2:M-1
   for n=2:N-1
       if x(m,n)==1
          W=x(m-1:m+1,n-1:n+1);
          maxW = max(W(:));
          if (x(m,n-1)==0 && maxW==1)
              x(m,n)=label;
              label=label+1;
          elseif maxW >= 1
              x(m,n) = maxW;
          end
       end
   end
end
% subplot(122);
imagesc(x);
axis image;
axis off;
title('labeled');


end