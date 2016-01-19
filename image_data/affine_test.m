function affine_test
clear all; close all;

x=[0 0 5 0];
y=[-3 3 0 0];

figure(1);
plot(x,y,'r--','LineWidth',2.5);hold on;
xmax=20;
ymax=xmax;

axis([-xmax,xmax,-ymax,ymax]);

axis square; grid on;
plot([-xmax,xmax],[0,0],'k');
plot([0,0],[-ymax,ymax],'k');
flag=[
    x
    y
    ones(1,length(x))
    ];

xshift=10;
yshift=5;
A=[
    1 0 xshift
    0 1 yshift
    0 0 1
];
flag=A*flag;x=flag(1,:);y=flag(2,:);plot(x,y,'b','LineWidth',2.5);

angle = pi/6;
B=[
    cos(angle) -sin(angle) 0
    sin(angle) cos(angle) 0
    0  0 1
];

flag=B*flag;x=flag(1,:);y=flag(2,:);plot(x,y,'g','LineWidth',2.5);

C=[
  -1 0 0
  0 1 0
  0 0 1
];

flag=C*flag;x=flag(1,:);y=flag(2,:);plot(x,y,'y','LineWidth',2.5);


end