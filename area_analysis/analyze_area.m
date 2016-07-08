function analyze_area

clear; close all;
tic;

if ~(exist('Ydata.mat', 'file') == 2)
    
    X0 = imread('cell.jpg');
    size(X0)
    subplot(331);
    imagesc(X0);
    axis image;
    axis off;
    title('raw');
    
    Xgray = (double(X0(:,:,1))+double(X0(:,:,2))+double(X0(:,:,3)))/3;
    X=Xgray;
    Xscale= (X-min(X(:)))/(max(X(:))-min(X(:)))*1;
    X=Xscale;
    %binarize
    X(X>=0.6)=1;
    X(X<0.6)=0;
    subplot(332);
    imagesc(X);
    axis image;
    axis off;
    title('binarized');
    colormap(gray);
    freezeColors;
    toc;
    
    Y=label_area(X);
    toc;
    
    n_lab = max(Y(:));
    subplot(333);
    imagesc(Y);
    axis image;
    axis off;
    NL = n_lab;
    colormap(jet);
    title('label');
    freezeColors;
    [M,N]=size(Y);
    for label=1:NL
        Z=zeros(M,N);
        for m=1:M
            for n=1:N
                if Y(m,n)==label
                    Z(m,n) = 1;
                end
            end
        end
        area(label)=sum(Z(:));
    end
    
    save('Ydata.mat');

else
    load('Ydata.mat');

    subplot(331);
    imagesc(X0);
    axis image;
    axis off;
    title('raw');

    subplot(332);
    imagesc(X);
    axis image;
    axis off;
    title('binarized');
    colormap(gray);
    freezeColors;

    subplot(333);
    imagesc(Y);
    axis image;
    axis off;
    colormap(jet);
    title('label');
    freezeColors;
    
end


subplot(3,3,[4 5 6]);
bar(area);
grid on;
axis([0 NL 0 2000]);
toc;

lower=201;
upper=6000;
Yout= Y*0;
Yo =isolateArea(Y,Yout,lower,upper);
subplot(337);
imagesc(uint8(Yo));
axis image;
axis off;
colormap(prism);
title('greater than 201');
freezeColors;
toc;

lower=1001;
upper=6000;
Yout= Y*0;
subplot(338);
Yo =isolateArea(Y,Yout,lower,upper);
imagesc(uint8(Yo));
axis image;
axis off;
colormap(prism);
title('greater than 1001');
freezeColors;
toc;

lower=51;
upper=6000;
Yout= Y*0;
subplot(339);
Yo =isolateArea(Y,Yout,lower,upper);
imagesc(uint8(Yo));
axis image;
axis off;
colormap(prism);
title('greater than 51');
freezeColors;
toc;


    function Yout=isolateArea(Y,Yout,lower,upper)
        for iLabel=1:NL
            for m=1:M
                for n=1:N
                    if Y(m,n)==iLabel
                        YY(m,n) = 1;
                    else
                        YY(m,n) = 0;
                    end
                end
            end
            labelArea = sum(YY(:));
            if labelArea >= lower && labelArea < upper
                Yout = Yout+YY;
            end
        end
    end


end