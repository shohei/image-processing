function test3
clear all; close all;

% XX=imread('myRose.jpg');

% XX=ones(size(512));
x=1:512;
y=1:512;
[X,Y]=meshgrid(x,y);
[THETA,R]=cart2pol(X,Y);
XX=cos((R.^2)/(45)^2).^2;

subplot(141);
imagesc(XX);
colormap(gray);
axis image;
axis off;

subplot(142);
Y1=downresol(XX);
imagesc(uint8(Y1));
colormap(gray);
axis image;
axis off;

subplot(143);
Y2=downresol(Y1);
imagesc(uint8(Y2));
colormap(gray);
axis image;
axis off;

subplot(144);
Y3=downresol(Y2);
imagesc(uint8(Y3));
colormap(gray);
axis image;
axis off;

    
    
    function Y=downresol(X)
        X=double(X);
        [M,N,C]=size(X);
        
        M=fix(M/2);
        N=fix(N/2);
        
        for c=1:C
            for m=1:M
                for n=1:N
                    Y(m,n,c) = X(2*m-1,2*n-1,c);
                end
            end
        end
        
    end








end