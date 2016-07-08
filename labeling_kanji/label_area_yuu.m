function label_area_yuu
clear all; close all;

X=imread('yuu.png');
X=double(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
Xgray = 1*(Xgray>120) + 0*(Xgray<=120);

x=Xgray;
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
subplot(131);
imagesc(x);
axis image;
axis off;
title('labeling step1');


lab1 = 0;
lab2 = 0;
loop=1;
Y=x;
while loop==1
    for m=2:M-1
        for n=2:N-1
            if Y(m,n) ~= 0;
                WY=Y(m-1:m+1,n-1:n+1);
                maxWY=max(WY(:));
                if Y(m,n) ~=maxWY;
                    lab1 = Y(m,n);
                    lab2 = maxWY;
                    loop = 1;
                    break;
                end
            else
                loop = 0;
            end
        end
        if loop==1
            break;
        end
    end
    
    for m=2:M-1
        for n=2:N-1
            if Y(m,n) == lab2
                Y(m,n) = lab1;
            end
        end
    end
end

subplot(132);
imagesc(Y);
axis image;
axis off;
title('labeling step2');


lab_vector = zeros(1,max(Y(:)));
for m=2:M-1
   for n=2:N-1
      if Y(m,n)>=1
         lab_vector(Y(m,n))=Y(m,n);
      end
   end
end

new_lab = [];
for k=1:length(lab_vector)
   if lab_vector(k)>0
       new_lab = [new_lab,lab_vector(k)];
   end
end

for k=1:length(new_lab)
   for m=1:M
      for n=1:N
         if Y(m,n) == new_lab(k)
             Y(m,n) = k;
         end
      end
   end
end

subplot(133);
imagesc(Y);
axis image;
axis off;
title('labeling step3');
colormap(colorcube)

end