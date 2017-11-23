function dct_2d
clear; close all;
format compact;

im = imread('cherry.jpg');
[X,Y,c] = size(im);
lN = X/8; % => 32
BN = lN*lN;
% im2 = zeros(8,8,c,BN);







%split_block();

%% check block splitting
% for yidx=1:lN
%     for xidx=1:lN
%         subplot(lN,lN,lN*(yidx-1)+xidx);
%         imagesc(im2(:,:,:,yidx*xidx));
%         colormap(gray);axis image; axis off;
%     end
%     yidx
% end

%     function split_block
%         for Yidx=1:lN
%             for Xidx=1:lN
%                 for yidx=1:8
%                     for xidx=1:8
%                         im2(yidx,xidx,1,Yidx*Xidx) = ...
%                           im(8*(Yidx-1)+yidx,8*(Xidx-1)+xidx,1);
%                         im2(yidx,xidx,2,Yidx*Xidx) = ...
%                           im(8*(Yidx-1)+yidx,8*(Xidx-1)+xidx,2);
%                         im2(yidx,xidx,3,Yidx*Xidx) = ...
%                           im(8*(Yidx-1)+yidx,8*(Xidx-1)+xidx,3);
%                     end
%                 end
%             end
%         end
%     end


end