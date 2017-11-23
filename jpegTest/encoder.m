function encoder

close all; clear;

%% initialization 
N = 256;
im = zeros(N,N,3);
im2 = zeros(N,N,3);
lN = (N/8);
BN = lN*lN;
im3 = zeros(8,8,3,BN);
% Ys = zeros(N,N);
% Cbs = zeros(N,N);
% Crs = zeros(N,N);
%% Main routine

im = makeRGB(im);
% subplot(121);
% imshow(im);
% title("original RGB");
%imwrite(im,'im.bmp');
for y=1:N
   for x=1:N
       R = im(y,x,1);
       G = im(y,x,2);
       B = im(y,x,3);       
       [Y,Cb,Cr] = RGB2YCbCR(R,G,B);
       im2(y,x,1) = Y;
       im2(y,x,2) = Cb;
       im2(y,x,3) = Cr;
       Ys(y,x) = Y;
       Cbs(y,x) = Cb;
       Crs(y,x) = Cr;       
   end
end

block_split();

imagesc(im2(:,:,3));
colormap(gray);
axis image;
axis off;

%% check block splitting

% idx=462;
% imagesc(im3(:,:,1,idx));%Only luminance Y
% im3(:,:,1,idx)
% colormap(gray);axis image; axis off;
% title(int2str(idx));

% for yidx=1:lN
%     for xidx=1:lN
%         subplot(lN,lN,yidx*xidx);
%         imagesc(im3(:,:,1,yidx*xidx));%Only luminance Y
%         colormap(gray);axis image; axis off;
%         title(int2str(yidx*xidx));
%     end
%     yidx
% end

    function block_split
        for yidx=1:lN
            for xidx=1:lN
                for y=1:8
                    for x=1:8
                        Y = im2(8*(yidx-1)+y,8*(xidx-1)+x,1);
                        Cb = im2(8*(yidx-1)+y,8*(xidx-1)+x,2);
                        Cr = im2(8*(yidx-1)+y,8*(xidx-1)+x,3);
                        im3(y,x,1,yidx*xidx) = Y;
                        im3(y,x,2,yidx*xidx) = Cb;
                        im3(y,x,3,yidx*xidx) = Cr;
                    end
                end
            end
        end
    end

    function im=makeRGB(im)
        im(1:85,:,1) = 250;
        im(86:171,:,2) = 250;
        im(172:256,:,3) = 250;
    end

    function [Y,Cb,Cr] = RGB2YCbCR(R,G,B)       
        Y = 0.299 * R + 0.587 * G + 0.114 * B - 128;
        Cb = - 0.1687 * R - 0.3313 * G + 0.5 * B + 128;
        Cr = 0.5 * R - 0.4187 * G - 0.0813 * B + 128;
    end




end