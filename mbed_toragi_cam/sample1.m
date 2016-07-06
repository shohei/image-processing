function sample1
clear all;
close all;

a=instrfind;delete(a(:));
s = serial('/dev/tty.usbmodem1422');
set(s,'BaudRate',115200);
fopen(s);
fprintf(s,'*IDN?')
out = fscanf(s);
out

for idx=1:120
  a = out(160*idx-159,160*idx);   
  a 
end

fclose(s)
delete(s)
clear s

end

