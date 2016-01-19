function Y=fnc_mfile(X,p)

[M,N]=size(X);

for m=1:M
    for n=1:N
       Y(m,n)=mod(m+n,p)+mod(m-n,p);
    end
end

X=X/max(X(:));
Y=Y/max(Y(:));
Y=(X+Y)/2;

end