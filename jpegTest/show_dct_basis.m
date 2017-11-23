function show_dct_basis
clear;
close all;

m = 8;
N = m*m;

    function F=getBasisF(u,v)
        F = zeros(m,m);
        for y=0:m-1
            for x=0:m-1
                F(y+1,x+1) = sqrt(2/m) * calcC(u)*calcC(v) ...
                    * cos(((2*x+1)*u*pi)/(2*m)) ...
                    * cos(((2*y+1)*v*pi)/(2*m));
            end
        end
    end

    function C=calcC(k)
        if k==0
            C=1/sqrt(2);
        else
            C=1;
        end
    end

Fs = zeros(m,m,N);
for vidx=0:m-1
    for uidx=0:m-1
        F = getBasisF(uidx,vidx);
        Fs(:,:,m*vidx+uidx+1) = F;
        subplot(m,m,m*vidx+uidx+1);
        imagesc(F);
        colormap(gray);
        axis image;
        axis off;
    end
end

end