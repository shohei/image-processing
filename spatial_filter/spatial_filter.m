function spatial_filter

clear all; close all;


X=imread('myRose.jpg');
X=double(X);
[M,N,R]=size(X);
Xgray=(X(:,:,1)+X(:,:,2)+X(:,:,3))/3;


subplot(1,4,1);
imagesc(uint8(Xgray));
axis image;
axis off;
colormap(gray);

subplot(1,4,2);
sobel_filter();
subplot(1,4,3);
sobel_positive();
subplot(1,4,4);
sobel_abs();

%     function average()
%         F = 1/9*[
%             1 1 1
%             1 1 1
%             1 1 1
%             ];
%         
%         for m=2:M-1
%             for n=2:N-1
%                 Xpart = Xgray(m-1:m+1,n-1:n+1);
%                 Xnew(m-1:m+1,n-1:n+1) = F.*Xpart;
%             end
%         end
%         image(uint8(Xnew));
%         axis image;
%         axis off;
%         colormap(gray);
%     end

%     function difference_filter()
%         F = 1/3*[
%             -1 0 1
%             -1 0 1
%             -1 0 1
%             ];
%         
%         for m=2:M-1
%             for n=2:N-1
%                 Xpart = Xgray(m-1:m+1,n-1:n+1);
%                 Xnew(m-1:m+1,n-1:n+1) = F.*Xpart;
%             end
%         end
%         image(uint8(Xnew));
%         axis image;
%         axis off;
%         colormap(gray);
%     end

    function sobel_filter()
        F = 1/4*[
            -1 0 1
            -2 0 2
            -1 0 1
            ];
        
        for m=2:M-1
            for n=2:N-1
                Xpart = Xgray(m-1:m+1,n-1:n+1);
                Xnew(m-1:m+1,n-1:n+1) = F.*Xpart;
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
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
                Xnew(m-1:m+1,n-1:n+1) = target;
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);
        
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
                Xnew(m-1:m+1,n-1:n+1) = abs(F.*Xpart);
            end
        end
        imagesc(uint8(Xnew));
        axis image;
        axis off;
        colormap(gray);        
    end


end