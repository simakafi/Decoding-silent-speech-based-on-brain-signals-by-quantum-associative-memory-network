function x_dot=nonlinearFunction(t,x,ut)
x1=x(1);
x2=x(2);
x3=x(3);
x4=x(4);

a1=0.2; a2=0.3; a3=0.1;
b1=1; b2=1;
c1=1; c2=0.5; c3=1; c4=1;
d1=0.2; d2=1;
r1=1.5; r2=1;
s=0.33;
alpha=0.3;
p=0.01;

x1_dot=r2*x1*(1-b2*x1)-c4*x1*x2-a3*x1*x4;

x2_dot=r1*x2*(1-b1*x2)-c2*x3*x2-c3*x2*x1-a2*x2*x4;

x3_dot=s+(p*x3*x2)/(alpha+x2)-c1*x3*x2-d1*x3-a1*x3*x4;

x4_dot=-d2*x4+ut;


x_dot=[x1_dot; x2_dot ;x3_dot; x4_dot];
