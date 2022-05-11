clear, clc, close all

files = dir("data/pendulum/*.mat");
len = length(files);

for i = 1:len
    filename = convertCharsToStrings(strcat([files(i).folder '/' files(i).name])); 
    data = load(filename);
    name = cell2mat(fieldnames(data));
    data = data.(name);

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
    
    fprintf('P Gain 1: %f \n', cart_position_gain)
    fprintf('V Gain 1: %f \n', cart_velocity_gain)
    
    figure()
    plot(time_data, [cart_position' cart_velocity' cart_position_command', pendulum_position' pendulum_velocity' raw_motor_voltage'])
    title(convertCharsToStrings(name))
    legend('position [m]', 'velocity[ms^-1]', 'position command [m]', 'pendulum position [rad]', 'pendulum velocity [rads^-1]', 'raw motor voltage [V]')
end


