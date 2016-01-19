function test1

clear all; close all;

X=ones(512);
for k=1:4
   p = 32*2^(4-k); 
   Y=fnc_mfile(X,p);
   figure(1);
   subplot(2,2,k);
   imagesc(Y);
   axis image;
   colormap(gray);
   axis off;
   X=Y;
end



end