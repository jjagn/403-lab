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

% pre-define matrix entries
% entry in A at pos (3,2)
A_32 = (-M_p^2 * L^2 * g)... 
    / ((M_c + M_p) * I_0 + M_c * M_p * L^2)

% entry in A at pos (3,3)
A_33 = ((I_0 + M_p * L^2) * (C * R * r^2 + k_m^2*k_g^2))...
    / (((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r^2)

% entry in A at pos (4,2)
A_42 = ((M_c + M_p) * M_p * L * g)...
    / ((M_c + M_p) * I_0 + M_c * M_p * L^2)

% entry in A at pos (4,3)
A_43 = (-M_p * L * (C * R * r^2 + k_m^2 * k_g^2))...
    /(((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r^2)

% define plant matrix A
A = [0 0 1 0;
    0 0 0 1;
    0 A_32 A_33 0;
    0 A_42 A_43 0]

% check to see that matrix entries are correct
assert(A(3,2) == A_32, 'matrix A positioning wrong')

% entry in B at pos (3,1)
B_31 = (-(I_0 + M_p * L^2) * k_m * k_g)...
    / (((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r)
% entry in B at pos (4,1)
B_41 = (M_p * L * k_m * k_g)...
    / (((M_c + M_p) * I_0 + M_c * M_p * L^2) * R * r)

% define input matrix B
B = [0;
    0;
    B_31;
    B_41]

% check to see that matrix entries are correct
assert(B(3,1) == B_31, 'matrix B positioning wrong')

% define sensor matrix C
C = eye(size(A))

% define whatever matrix D is
D = 0

sys = ss(A, B, C, D)

%% DESIGNING CONTROL GAINS
% set system poles
poles = [-5+1i -5-1i -10+2i -10-2i]; % these are just guesses

K = place(A, B, poles)

ACL = (A - B*K)

sys = ss(ACL, B, C, D)

Q = diag([1, 1, 100, 100]);
R = 1;

K = lqr(sys, Q, R)

%% SYSTEM RESPONSE

figure
impulse_plot = impulseplot(sys);

figure
step_plot = stepplot(sys);
