clc; clear; close all

%% SET UP SIMULATED SYSTEM
m1 = 1.608;
m2 = 0.75;
m3 = m2;
k = 175;
c1 = 0;
c2 = 3.68;
c3 = c2;
alpha = 12.45;
bigR = 1.4;
r = 0.0184;
ref = 0.25;
kg = 3.71;
km = 0.00176;

A41 = -k/m1;
A44 = (1/m1)*(-c1-((km^2*kg^2)/(bigR*r^2)));
A42 = k/m1;
A51 = k/m2;
A52 = (-2*k)/m2;
A55 = -c2/m2;
A62 = k/m3;
A66 = -c3/m3;
A53 = k/m2;
A63 = -k/m3;

B41 = (alpha*km*kg)/(m1*bigR*r);

A = [0     0     0   1   0    0;
     0     0     0   0   1    0;
     0     0     0   0   0    1;
     A41  A42   0   A44  0    0;
     A51  A52  A53   0  A55   0;
     0    A62  A63   0   0   A66];
 
B = [0;
     0;
     0;
     B41;
     0;
     0];
  
C = eye([6 6]);
  
D = 0;

K = [22.32 5.46 2.25 4.84 1.24 0.87];

C_p = [0 0 1 0 0 0];

ACL = (A - B*K);

sys = ss(ACL, B, C, D);

N = -inv(C_p*inv(ACL)*B);

sys.B = N*sys.B;
%% CHECK DIRECTORY FOR MAT FILES
files = dir("data/3 cart/*.mat");
len = length(files);
% len = 1; % set len to 1 so we don't waste time iterating through all the files when we don't need to
figure()
hold on

% making plots pretty + readable
FontSize = 16;
lineSpecs = ["-";"--";":";"-."];
fontsize(gca, FontSize, 'points')


% for shifting plots around
main_start = 12637;
dur = 8000;
%% MAIN LOOP
for i = 5
    % get filename from files struct
    filename = convertCharsToStrings(strcat([files(i).folder '/' files(i).name])); 
    data = load(filename);

    % unpack data so we don't have to hardcode the name every time
    name = cell2mat(fieldnames(data));
    data = data.(name);
    name_str = convertCharsToStrings(name);

    % pull out data from struct
    time_data = data.X(1).Data;
	
    C1P = data.Y(1).Data;
    C1P_GAIN = data.Y(2).Data(1);
    C1V = data.Y(3).Data;
    C1V_GAIN = data.Y(4).Data(1);

    C2P = data.Y(5).Data;
    C2P_GAIN = data.Y(6).Data(1);
    C2V = data.Y(7).Data;
    C2V_GAIN = data.Y(8).Data(1);

    C3P = data.Y(9).Data;
    C3P_GAIN = data.Y(10).Data(1);
    C3V = data.Y(11).Data;
    C3V_GAIN = data.Y(12).Data(1);

    CMV = data.Y(13).Data;
    PC = data.Y(14).Data;
    RMV = data.Y(15).Data;

    %% PRINT GAINS

    fprintf('%s gains\n', name_str)
    
    fprintf('P Gain 1: %f \n', C1P_GAIN)
    fprintf('P Gain 2: %f \n', C2P_GAIN)
    fprintf('P Gain 3: %f \n', C3P_GAIN)
    fprintf('V Gain 1: %f \n', C1V_GAIN)    
    fprintf('V Gain 2: %f \n', C2V_GAIN)
    fprintf('V Gain 3: %f \n', C3V_GAIN)

    fprintf('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n')
    
    %% PLOT FIGURES

    % position plot
    
    % plot(time_data, [C1P' C2P' C3P' PC'], 'LineWidth', 3
%     lineSpec = lineSpecs(i-4);
    lineSpec = lineSpecs(2);
    if (i == 5)
        start = 13555;
        time_data = time_data - (13.555-12.637) - 12.637;
        end_time = start + dur;
        plot(time_data(start:end_time), C3P(start:end_time), lineSpec, 'LineWidth', 3)
    elseif (i == 6)
        start = 12637-231;
        time_data = time_data - start/1000;
        end_time = start + dur;
        plot(time_data(start:end_time), C3P(start:end_time), lineSpec, 'LineWidth', 3)
    elseif (i == 7)
    start = 12637+100;
    time_data = time_data - start/1000;
    end_time = start + dur;
    plot(time_data(start:end_time), C3P(start:end_time), lineSpec, 'LineWidth', 3)
    else
        start = 12637;
        time_data = time_data - start/1000;
        end_time = start + dur;
        plot(time_data(start:end_time), C3P(start:end_time), lineSpec, 'LineWidth', 3)
    end
end
xlim([0, time_data(end_time)])
xlabel('Time [s]', 'FontSize', FontSize)
ylabel('Cart 3 position [m]', 'FontSize', FontSize)

%% PLOT SIMULATED RESPONSE
[Y, T, XT] = lsim(sys, PC(start:end_time), time_data(start:end_time));
plot(T,XT(:,3), lineSpecs(3), 'LineWidth', 3) % plot only pos of cart 3
plot(time_data(start:end_time), PC(start:end_time), lineSpecs(1), 'Linewidth', 2)
% legend('Original System', 'Weight on cart 2', 'Weight on cart 3', 'Weight on carts 2 & 3', 'Position Command', 'Simulated response', 'Fontsize', FontSize)
legend('Cart 3 position, experimental', 'Cart 3 position, simulated', 'Position command')
% calculate voltage and slew
V = PC(start:end_time) - K*XT';
DV = gradient(V);
max(abs(V))
figure(2)
plot(T,V)

stepinfo = stepinfo(sys);
state3_info = stepinfo(3);
state3_rise = state3_info.RiseTime;
state3_settle = state3_info.SettlingTime;
