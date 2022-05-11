clc
clear 
close all


m1 = 1.608;
m2 = 0.75;
m3 = m2;
k = 175;
c1 = 0;
c2 = 3.68;
c3 = c2;
alpha = 12.45;
R = 1.4;
r = 0.0184;
ref = 0.5;
kg = 3.71;
km = 0.00176;

A41 = m1*k;
A44 = (c1*m1)-((m1*km^2*kg^2)/(R*r^2));
A42 = -k*m2;
A51 = -m2*k;
A52 = 2*m2*k;
A55 = c2*m2;
A62 = -m3*k;
A66 = c3*m3;
A53 = -k*m2;
A63 = k*m3;

B41 = (m1*alpha*km*kg)/(R*r);

A = [0     0   0   1   0    0;
     0     0   0   0   1    0;
     0     0   0   0   0    1;
     A41   A42   0  A44  0    0
     A51  A52  A53   0   A55  0
     0    A62  A63   0    0  A66];
 
B = [0;
     0;
     0;
     B41;
     0;
     0];
  
C = eye(6);
  
D = 0;
  
sys = ss(A, B, C, D);
  
CMatrix = ctrb(sys);
OMatrix = obsv(sys);
  
eig(sys);

%% DESIGNING CONTROL GAINS
% set system poles
C_prime = [0 0 1 0 0 0]

Q = diag([1 1 1000 1 1 1]);
lqR = 10;

K = lqr(sys, Q, lqR)

ACL = (A - B*K) % closed loop A matrix
N = -inv(C_prime*inv(ACL)*B)
B_hat = B*N*ref
names = {'x1' 'x2' 'x3' 'dx1', 'dx2', 'dx3'};
sys = ss(ACL, B_hat, C, D)
sys.StateName = names;
sys.OutputName = names;

%% SYSTEM RESPONSE
figure(1)
[Y, T, XT] = step(sys);

% calculate voltage and slew
V = N*ref - K*XT';
DV = gradient(V);

% plot system step response
step_plot = stepplot(sys);

% pull out system characteristics
info = stepinfo(sys)

% get x and theta characteristics from struct
x_info = info(1)
theta_info = info(2)

% printing characteristics for each parameter/state
x_rise_time = x_info.RiseTime
x_settling_time = x_info.SettlingTime
theta_settling_time = theta_info.SettlingTime


% plots
figure(2)
plot(T,Y)
legend('x', 'theta', 'dx', 'dtheta')
figure(3)
plot(T, [V', DV'])
legend('Voltage [V]', 'Slew Rate [Vs^-1]')

% check voltage parameters within acceptable limits
assert(max(abs(V)) < 10, 'voltage request too high')
assert(max(abs(DV)) < 30, 'voltage slew request too high')

% print important info for lab at program end
N
K
