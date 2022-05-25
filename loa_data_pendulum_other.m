clear, clc, close all

%% CHECK DIRECTORY FOR MAT FILES
files = dir("data/pendulum/*.mat");
len = length(files);

figure(1)
hold on
figure(2)
hold on

% making plots pretty + readable
FontSize = 20;
lineSpecs = ["-";"--";":";"-.";"-"];
fontsize(gca, FontSize, 'points')
to_print = [5 6 7 8 10];

%% MAIN LOOP
for i = 1:len
    % get filename from files struct
    filename = convertCharsToStrings(strcat([files(i).folder '/' files(i).name])); 
    data = load(filename);

    % unpack data so we don't have to hardcode the name every time
    name = cell2mat(fieldnames(data));
    data = data.(name);
    name_str = convertCharsToStrings(name);

    % pull out data from struct
    time_data = data.X(1).Data;
	    
    cart_position = data.Y(1).Data;
    cart_position_gain = data.Y(2).Data(1);
    cart_velocity = data.Y(3).Data;
    cart_velocity_gain = data.Y(4).Data(1);
    tracking_gain = data.Y(5).Data(1);
    cart_position_command = data.Y(6).Data;
    pendulum_position_gain = data.Y(7).Data(1);
    pendulum_position = data.Y(8).Data;
    pendulum_velocity = data.Y(9).Data;
    pendulum_velocity_gain = data.Y(10).Data(1);
    raw_motor_voltage = data.Y(11).Data;

    fprintf('Gains for %s\n', name)
    fprintf('Cart P Gain: %f \n', cart_position_gain)
    fprintf('Cart V Gain: %f \n', cart_velocity_gain)
    fprintf('Pend P Gain: %f \n', pendulum_position_gain)
    fprintf('Pend V Gain: %f \n', pendulum_velocity_gain)
    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
    
    %lineSpec = lineSpecs(i)
    if (ismember(i, to_print))
        disp(i)
        figure(1)
        plot(time_data, raw_motor_voltage, 'LineWidth', 3)
        figure(2)
        plot(time_data, [cart_position', pendulum_position'], 'LineWidth', 3)
    end
end

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

%% DESIGNING CONTROL GAINS
% set system poles
C_prime = [0 0 1 0 0 0]

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

% plots
figure(2)
plot(T,Y)
legend('x', 'theta', 'dx', 'dtheta')
figure(3)
plot(T, [V', DV'])
legend('Voltage [V]', 'Slew Rate [Vs^-1]')

figure(1)
legend('voltage 1', 'voltage 2', 'voltage 3', 'voltage 4')
figure(2)
legend('position 1 [m]', 'pendulum position 1 [rad]',...
    'position 2 [m]', 'pendulum position 2 [rad]',...
    'position 3 [m]', 'pendulum position 3 [rad]',...
    'position 4 [m]', 'pendulum position 4 [rad]')
figure(3)
legend('position 1 [m]', 'pendulum position 1 [rad]',...
    'position 2 [m]', 'pendulum position 2 [rad]',...
    'position 3 [m]', 'pendulum position 3 [rad]',...
    'position 4 [m]', 'pendulum position 4 [rad]')


