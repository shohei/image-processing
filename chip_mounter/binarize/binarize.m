function binarize
clear;
close;

img = imread('./chip.png');

R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));
g = (R+G+B)/3;

subplot(121);
g8 = sobel(g);
imagesc(abs(g8));
axis image;
axis off;
colormap(gray);
title('sobel filter (absolute)')

subplot(122);
g8 = lap_filter(g);
imagesc(abs(g8));
axis image;
axis off;
colormap(gray);
title('laplacian filter (absolute)');

saveas(gcf,'result.png')

% imsave(gcf,'result.png');
% g8 = uint8(g);
% imshow(g8sc);
% imgsc = imscale(img);
% imshow(img);



end