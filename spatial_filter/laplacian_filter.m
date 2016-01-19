function laplacian_filter

clear all ;close all;
X=imread('USAF.png');
image(X);
axis image;
axis off;
X=double(X);
[M,N,R]=size(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;

subplot(121);
imagesc(uint8(Xgray));
colormap(gray);
axis off;
axis image;

F = 1/4*[
    0 1 0
    1 -4 1
    0 1 0
];

for m=2:M-1
   for n=2:N-1
      Xp = Xgray(m-1:m+1,n-1:n+1); 
      Xnew(m,n) = sum(sum(F.*Xp));
   end
end

subplot(122);
imagesc(uint8(Xnew));
colormap(gray);
axis off;
axis image;


end