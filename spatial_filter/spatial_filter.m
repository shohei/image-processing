function spatial_filter

clear all; close all;


X=imread('myRose.jpg');
X=double(X);
[M,N,R]=size(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;


subplot(2,4,1);
imagesc(uint8(Xgray));
axis image;
axis off;
colormap(gray);
title('original');

subplot(2,4,2);
sobel_filter();
subplot(2,4,3);
sobel_positive();
subplot(2,4,4);
sobel_abs();

subplot(2,4,5);
average();
title('Average');
subplot(2,4,6);
difference_filter();
title('Difference');

subplot(2,4,7);
sobel_negative();


    function average()
        F = 1/9*[
            1 1 1
            1 1 1
            1 1 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                Xnew(m,n) = sum(sum(F.*Xpart));
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
    end

    function difference_filter()
        F = 1/3*[
            -1 0 1
            -1 0 1
            -1 0 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                Xnew(m,n) = sum(sum((F.*Xpart)));
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
    end

    function sobel_filter()
        F = 1/4*[
            -1 0 1
            -2 0 2
            -1 0 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                Xnew(m,n) = sum(sum(F.*Xpart));
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
        title('sobel filter');
    end

    function sobel_positive
        F = 1/4*[
            -1 0 1
            -2 0 2
            -1 0 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                target=F.*Xpart.*(F.*Xpart>0);
                Xnew(m,n) = sum(sum(target));
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
        title('sobel filter(>0)');        
    end

    function sobel_negative
        F = 1/4*[
            -1 0 1
            -2 0 2
            -1 0 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                target=F.*Xpart.*(F.*Xpart<0);
                Xnew(m,n) = abs(sum(sum(target)));
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
        title('sobel filter(<0)');        
    end


    function sobel_abs
        F = 1/4*[
            -1 0 1
            -2 0 2
            -1 0 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                Xnew(m,n) = sum(sum(abs(F.*Xpart)));
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);        
        title('sobel filter(ABS)');        
    end


end