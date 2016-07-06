function android_cam_stream

baseaddr = '192.168.100.100:8080';

url = 'http://'+baseaddr+'/shot.jpg';
ss  = imread(url);
fh = image(ss);
while(1)
    ss  = imread(url);
    set(fh,'CData',ss);
    drawnow;
end


end