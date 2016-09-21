function out = sobel(grayDouble)

[x,y] = size(grayDouble);
Fsobel = 1/3*[-1 0 1;-1 0 1;-1 0 1];

for n=2:y-1
    for m=2:x-1
        out(m-1:m+1,n-1:n+1) = Fsobel * grayDouble(m-1:m+1,n-1:n+1);       
    end
end


end