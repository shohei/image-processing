function rect_test
clear all; close all;

figure; hold on;

a = 1;
x0 = 0;
div = 100;

x = linspace(-10,10,div);

for time=0:9
  x0 = time;
  y = a*exp(-2*pi*i*x0*x).*sin(a*pi*x)./(a*pi*x);
  drawSINC(x,y);
  g = (x>x0-a/2) .* (x<x0+a/2);
  plot(x,g,'r');
  drawnow;
  pause(0.3);
  if(time>8)       
      break;
  end
  cla();
end


    function drawSINC(x,y)
        plot(x,y,'b');                
    end

end