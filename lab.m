clear, clc, close all;

% defining params
A = [-1 4;
    0 -2];
B = [1;
    1];
C = [1 0];

D = 0;

sys = ss(A, B, C, D)
CMatrix = ctrb(sys)
OMatrix = obsv(sys)

Y_U = tf(sys)

[V, E] = eig(A)
%% DESIGNING CONTROL GAINS
poles = [-10+1i -10-1i];

K = place(A, B, poles);

ACL = (A - B*K);

sys = ss(ACL, B, C, D);

Q = diag([100,1]);
R = 1;

K = lqr(sys, Q, R);

%% SYSTEM RESPONSE

sys.B = 0.1*sys.B;

figure
impulse(sys)

figure
step(sys)
