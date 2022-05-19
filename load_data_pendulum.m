clear, clc, close all

%% CHECK DIRECTORY FOR MAT FILES
files = dir("data/pendulum/*.mat");
len = length(files);

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
    
    figure()
    plot(time_data, [cart_position' cart_position_command' pendulum_position' raw_motor_voltage'], 'LineWidth', 3)
    title(convertCharsToStrings(name))
    legend('position [m]','position command [m]', 'pendulum position [rad]', 'raw motor voltage [V]')
end


