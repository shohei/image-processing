function binalize

clear all; close all;

X=imread('lena.jpg');
X=double(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;
[M,N,R]=size(X);

subplot(2,4,1);
imagesc(uint8(Xgray));
colormap(gray);
axis image;
axis off;

subplot(2,4,2);
naive_threshold(120);
title('Th=120');
subplot(2,4,3);
naive_threshold(150);
title('Th=150');
subplot(2,4,4);
naive_threshold(200);
title('Th=200');

subplot(2,4,5);
variable_threshold(20);
title('a=20');

subplot(2,4,6);
variable_threshold(80);
title('a=80');

subplot(2,4,7);
variable_threshold(120);
title('a=120');

subplot(2,4,8);
variable_threshold(200);
title('a=200');



    function variable_threshold(a)
        for m=1:M
            for n=1:N
                m1=m-a;
                if m1<1
                    m1=1;
                end
                m2=m+a;
                if m2>=M
                   m2=M;
                end
                n1=n-a;
                if n1<1
                    n1=1;
                end
                n2=n+a;
                if n2>=N
                   n2=N;
                end
                W = Xgray(m1:m2,n1:n2);
                meanW=mean(W(:));
                stdW=std(W(:));
                if (stdW/meanW >=0.3) && (Xgray(m,n)<=meanW)
                   Xnew(m,n) = 0; %black
                else
                    Xnew(m,n) = 255; %white;
                end
            end
        end        
        imagesc(uint8(Xnew));
        colormap(gray);
        axis image;
        axis off;               
    end

    
    function naive_threshold(threshold)
        for m=1:M
            for n=1:N
                if Xgray(m,n) > threshold
                    Xnew(m,n) = 255; %white
                else
                    Xnew(m,n) = 0; %black
                end
            end
        end        
        imagesc(uint8(Xnew));
        colormap(gray);
        axis image;
        axis off;        
    end


end