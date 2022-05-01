clear, clc, close all;

% define parameters
M_p = 0.215;        % Pendulum mass                     [kg]
M_c = 1.608;        % Cart mass                         [kg]
L = 0.314;          % Effective pendulum half length    [m]
I_0 = 7.06 * 10^-3; % Pendulum moment of inertia        [kg*m^2]
R = 0.16;           % Motor terminal resistance         [ohms]
r = 0.0184;         % Pinion radius                     [m]
k_g = 3.71;         % Gearing ratio                     [unitless]
k_m = 0.0168;       % Motor BEMF constant               [V*s*rad^-1]
C = 0;              % Cart damping                      [N*s*m^-1]
g = 9.81;           % Gravitational acceleration        [m*s^2]
ref = 0.1;          % tracking reference                [m]

% pre-define matrix entries
% entry in A at pos (3,2)
A_32 = (-M_p^2 * L^2 * g)... 
    / ((M_c + M_p) * I_0 + M_c * M_p * L^2);

% entry in A at pos (3,3)
A_33 = ((I_0 + M_p * L^2) * (C * R * r^2 + k_m^2*k_g^2))...
    / (((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r^2);

% entry in A at pos (4,2)
A_42 = ((M_c + M_p) * M_p * L * g)...
    / ((M_c + M_p) * I_0 + M_c * M_p * L^2);

% entry in A at pos (4,3)
A_43 = (-M_p * L * (C * R * r^2 + k_m^2 * k_g^2))...
    /(((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r^2);

% define plant matrix A
A = [0 0 1 0;
    0 0 0 1;
    0 A_32 A_33 0;
    0 A_42 A_43 0];

% check to see that matrix entries are correct
assert(A(3,2) == A_32, 'matrix A positioning wrong')

% entry in B at pos (3,1)
B_31 = (-(I_0 + M_p * L^2) * k_m * k_g)...
    / (((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r);
% entry in B at pos (4,1)
B_41 = (M_p * L * k_m * k_g)...
    / (((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r);

% define input matrix B
B = [0;
    0;
    B_31;
    B_41];

% check to see that matrix entries are correct
assert(B(3,1) == B_31, 'matrix B positioning wrong')

% define sensor matrix C
C = eye(size(A));
% C' for calculating N later on
C_prime = [1 0 0 0];

% define whatever matrix D is
D = 0;

%% DESIGNING CONTROL GAINS
% set system poles

poles = [-10+2i -10-2i -15+1i -15-1i]; % these are just guesses

% place poles
K = place(A, B, poles)

ACL = (A - B*K) % closed loop A matrix;
N = -inv(C_prime*inv(ACL)*B)
B_hat = B*N*ref
names = {'v' 'theta' 'dv' 'dtheta'};
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