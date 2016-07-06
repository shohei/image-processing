function Y=fnc_Labeling

X=(X-min(X(:)))/(max(X(:))-min(X(:)));
[M,N]=size(X);
X(1,:)=0;
X(M,:)=0;
X(:,1)=0;
X(:,N)=0;
label = 30;
for m=2:M-1
    for n=2:N-1
        if (X(m,n)==1
            W=X(m-1:m+1,n-1:n+1);
            maxW=max(W(:));
            if(X)
            
        









end