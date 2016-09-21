function binarize
clear;
close;

img = imread('~/Downloads/chip.jpg');

R = double(img(:,:,1));
G = double(img(:,:,2));
B = double(img(:,:,3));
gray = (R+G+B)/3;
gray8 = uint8(gray);

imshow(scale(gray8));
% imgsc = imscale(img);
% imshow(img);



end