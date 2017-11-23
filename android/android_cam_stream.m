function android_cam_stream
clear all;
close all;

baseaddr = '192.168.100.7:8080';

url = strcat('http://',baseaddr,'/shot.jpg');
ss  = imread(url);
fh = image(ss);
while(1)
    ss =  flipdim(flipdim(imread(url),1),2);
%      s = InverseAffine(ss);
    set(fh,'CData',ss);
    drawnow;
end


    function Xnew=InverseAffine(ss)
        X=double(ss);
        [M,N,R]=size(X);
        T = [cos(pi) -sin(pi)
            sin(pi) cos(pi)];
        for m=1:M %scan for 'new' coordinate
            for n=1:N
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
        disp 'done'
        Xnew=uint8(New);
    end

end