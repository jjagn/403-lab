clear, clc, close all
filename = "data/jdw144lqr1_pendulum_2may.mat";
load(filename);

data = jdw144lqr1;

time_data = data.X(1).Data;

C1P = data.Y(1).Data;
C1P_GAIN = data.Y(2).Data(1);
C1V = data.Y(3).Data;
C1V_GAIN = data.Y(4).Data(1);

C2P = data.Y(5).Data;
C2P_GAIN = data.Y(6).Data;
C2V = data.Y(7).Data;
C2V_GAIN = data.Y(8).Data;

CMV = data.Y(9).Data;
PC = data.Y(10).Data;
RMV = data.Y(11).Data;

fprintf('P Gain 1: %f \n', C1P_GAIN)
fprintf('V Gain 1: %f \n', C1V_GAIN)

fprintf('P Gain 2: %f \n', C2P_GAIN)
fprintf('V Gain 2: %f \n', C2V_GAIN)

plot(time_data, [C1P' C1V'])
