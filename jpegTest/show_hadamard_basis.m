function show_hadamard_basis
clear;
close all;

m = 8;
N = m*m;
b = 3; % <8> can be expressed with <3> bit

    function F=getBasisF(u,v)
        F = zeros(m,m);
        for yidx=0:m-1
            for xidx=0:m-1
                F(yidx+1,xidx+1) = (-1)^getQ(xidx,yidx,u,v);
            end
        end
        F = 1/m * F;
    end

    function q=getQ(x,y,u,v)
        q = 0;
        for idx=0:b-1
            q = q + Bit(idx,x)*getG(idx,u) + Bit(idx,y)*getG(idx,v);
        end
    end

    function g = getG(i,u)
        g = Bit(b-i,u) + Bit(b-i-1,u);
    end

    function bit = Bit(index,u)
        filter = bitshift(1, index);
        flag = bitand(u,filter);
        if flag ~= 0
            bit = 1;
        else
            bit = 0;
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