function power_spectrum_rect

clear; close all;
N=100;

for x0 = linspace(10,90,8)
    g=zeros(1,N);    
    g(x0+1:x0+10) = 1;
    power=abs(fft(g)).^2;
    power = power/max(power);
    p_shifted = fftshift(power);
    
    figure(1);
    subplot(311);
    plot(g,'LineWidth',1.5);
    axis([1,N,0,max(g)]);
    grid on;
    
    % hold on;
    subplot(312);
    plot(power,'LineWidth',1.5);
    axis([1,N,0,max(power)]);
    grid on;
    
    subplot(313);
    plot(p_shifted,'LineWidth',1.5');
    axis([1,N,0,max(p_shifted)]);
    grid on;
    drawnow;
    pause(1);
    
    
end


end