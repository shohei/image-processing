function out = lap_filter(grayDouble)

[x,y] = size(grayDouble);
Flap = 1/4*[-1 0 1;-2 0 2;-1 0 1];

for n=2:y-1
    for m=2:x-1
        out(m-1:m+1,n-1:n+1) = Flap * grayDouble(m-1:m+1,n-1:n+1);
    end
end


end
