function median_filter
clear all; close all;

% createNoisyPic();

Y=imread('rotRose.jpg');
Y=double(Y);
[J,K,L]=size(Y);
Ygray=(Y(:,:,1)+Y(:,:,2)+Y(:,:,3))/3;
subplot(121);
imagesc(uint8(Ygray));
axis image;
axis off;
colormap(gray);
title('ORIGINAL');

for j=2:J-1
    for k=2:K-1
        Ypart = Ygray(j-1:j+1,k-1:k+1);
        YpartArray = reshape(Ypart,1,[]);
        Ysorted = sort(YpartArray);
        med = Ysorted(floor(length(Ysorted)/2));
        Ynew(j,k)=med;
    end
end

subplot(122);
imagesc(uint8(Ynew));
axis image;
axis off;
colormap(gray);
title('MEDIAN FILTER');


    function createNoissyPic()        
        
        X=imread('myRose.jpg');
        X=double(X);
        [M,N,R]=size(X);
        
        theta=36*pi/180;
        T=[
            cos(theta)  -sin(theta)
            sin(theta) cos(theta)
            ];
                
        for m=1:M
            for n=1:N
                m0=round(M/2);
                n0=round(N/2);
                xold = n-n0;
                yold= -m+m0;
                xy_new = T*[xold yold]';
                xnew = xy_new(1);
                ynew= xy_new(2);
                mnew = round(-ynew+m0);
                nnew = round(xnew+n0);
                if(mnew>0 && nnew>0)
                    for idx=1:R
                        Xnew(mnew,nnew,idx) = X(m,n,idx);
                    end
                end
            end
        end
        
        imagesc(uint8(Xnew));
        axis off;
        axis image;
        imwrite(uint8(Xnew),'rotRose.jpg');       
    end

end