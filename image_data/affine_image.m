function affine_image
clear all; close all;

X=imread('myRose.jpg');
% image(X);
axis image;
axis off;

X=double(X);
[M,N,R]=size(X);

theta=36*pi/180;
T=[cos(theta) -sin(theta)
    sin(theta) cos(theta)];

original();
Affine();
InverseAffine();
    
    function original()
        subplot(131);
        Xnew=uint8(X);
        image(Xnew);
        axis image;
        axis off;
        title('original');
    end

    function Affine()
        for m=1:M %scan for 'old' coordinate
            for n=1:N
                m0=round(M/2);
                n0=round(N/2);
                
                xold = n-n0;
                yold = -m+m0;
                xy_new = T*[xold yold]';
                xnew = xy_new(1);
                ynew = xy_new(2);
                m_new = round(-ynew+m0);
                n_new = round(xnew+n0);
                if(m_new>0 && n_new>0)
                    for idx=1:R
                        New(m_new,n_new,idx) = X(m,n,idx);
                    end
                end
            end
        end
        subplot(132);
        Xnew=uint8(New);
        image(Xnew);
        axis image;
        axis off;                               
        title('Affine map');
    end


    function InverseAffine()
        for m=1:M %scan for 'new' coordinate
            for n=1:N
                %         for idx=1:R
                %             rgb(idx) = X(m,n,idx);
                %         end
                mnew0=round(M/2);
                nnew0=round(N/2);
                
                xnew = n-nnew0;
                ynew = -m+mnew0;
                xy_old = inv(T)*[xnew ynew]';
                xold = xy_old(1);
                yold = xy_old(2);
                m_old = round(-yold+mnew0);
                n_old = round(xold+nnew0);
                if(m_old>0 && m_old<M && n_old>0 && n_old <N)
                    for idx=1:R
                        New(m,n,idx) = X(m_old,n_old,idx);
                    end
                end
            end
        end
        subplot(133);
        Xnew=uint8(New);
        image(Xnew);
        axis image;
        axis off;        
        title('Affine map[inverse]');
    end


end