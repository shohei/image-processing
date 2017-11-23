function detector

clear all;
close all;

X = imread('bw.png');
X = X(:,:,1);
X = double(X);
X=(X-min(X(:)))/(max(X(:))-min(X(:)));
subplot(121);
imagesc(X);
axis image;
axis off;
colormap(gray);
drawnow;

[M,N]=size(X);
Y=zeros(M,N);

for m=2:M-1
    for n=2:N-1
        if X(m,n)==1
           W = X(m-1:m+1,n-1:n+1) ;
           [N8C,N4C] = computeN8N4(W);
           if N8C >= 1
              Y(m,n) = 1;
           end
        end
    end
end

for m=2:M-1
   for n=2:N-1
      if Y(m,n) ==1
         W = Y(m-1:m+1,n-1:n+1);
         [N8C,N4C] = computeN8N4(W);
         if N8C ~= 2
            Y(m,n) = 0;
         end         
      end
   end
end

subplot(122);
imagesc(Y);
axis image;
axis off;
colormap(gray);
drawnow;



end