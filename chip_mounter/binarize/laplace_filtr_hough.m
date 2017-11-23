function laplace_filtr_hough
clear;
close;

img = imread('./chip.png');

R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));
g = (R+G+B)/3;

g = lap_filter(g);

bw = zeros(size(g));
bw(g>10) = 1;

imagesc(bw);
colormap(gray);
axis image;
axis off;

saveas(gcf,'bw_lap.png')


% [m,n] = size(bw);
% out = zeros(size(bw));
% for y=2:n-1
%    for x=2:m-1
%        W = bw(x-1:x+1,y-1:y+1);
%        Wsort = sort(W(:));
%        mid = Wsort(5); %median filter
%        out(x,y)=mid;
%    end
% end


% bw(bw==1)=0;
% bw(bw==0)=1;

% subplot(121);
% imagesc(bw);
% colormap(gray);
% axis image;

% subplot(122);
% imagesc(out);
% colormap(gray);
% axis image;
% axis off;

% subplot(121);
% g8 = sobel(g);
% imagesc(abs(g8));
% axis image;
% axis off;
% colormap(gray);
% title('sobel filter (absolute)')
% 
% subplot(122);
% g8 = lap_filter(g);
% imagesc(abs(g8));
% axis image;
% axis off;
% colormap(gray);
% title('laplacian filter (absolute)');
% 

% imsave(gcf,'result.png');
% g8 = uint8(g);
% imshow(g8sc);
% imgsc = imscale(img);
% imshow(img);



end