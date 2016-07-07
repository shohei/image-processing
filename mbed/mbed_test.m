function mbed_test

%clear
a = instrfind; delete(a(:));

s = serial('/dev/tty.usbmodem1422', 'BaudRate', 115200);
fopen(s);

for idx=1:160
    idx
  line = fgetl(s);    
  result(idx,:) = line;
end
fprintf(s,'\n');

fid=fopen('captureData.txt','w');
fprintf(fid, '%s',result);
fclose(fid);


fclose(s);

end