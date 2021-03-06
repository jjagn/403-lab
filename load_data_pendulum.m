clear, clc, close all

%% CHECK DIRECTORY FOR MAT FILES
files = dir("data/pendulum/*.mat");
len = length(files);

% making plots pretty + readable
FontSize = 20;
lineSpecs = ["-";"--";":";"-."];
fontsize(gca, FontSize, 'points')

%% MAIN LOOP
for i = 2:3
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
    
    figure(i-1)
    plot(time_data, [cart_position' cart_position_command' pendulum_position'], 'LineWidth', 3)
    %title(convertCharsToStrings(name))
    legend('Position [m]','Position command [m]', 'Pendulum position [rad]')
    xlabel('Time [s]', 'FontSize', FontSize)
    xlabel('', 'FontSize', FontSize)
    fontsize(gca, FontSize, 'points')

    
    start_pos = 8111-3438;

    figure(4)
    hold on
    plot(time_data, cart_position, 'LineWidth', 3)
%     if i == 3
%         time_data = time_data+start_pos/1000;
%         plot(time_data(1:end-start_pos), cart_position(1:end-start_pos), 'LineWidth', 3)
%     else
%         plot(time_data(start_pos:end), cart_position(start_pos:end), 'LineWidth', 3)
%     end
    hold off

    figure(5)
    hold on
    plot(time_data, pendulum_position, 'LineWidth', 3)
    hold off

end

figure(4)
legend('Gain set 1', 'Gain set 2', 'Gain set 3')
xlabel('Time [s]', 'FontSize', FontSize)
ylabel('Cart position [m]', 'FontSize', FontSize)
fontsize(gca, FontSize, 'points')
figure(5)
legend('Gain set 1', 'Gain set 2', 'Gain set 3')
xlabel('Time [s]', 'FontSize', FontSize)
ylabel('Pendulum position [rad]', 'FontSize', FontSize)
fontsize(gca, FontSize, 'points')


