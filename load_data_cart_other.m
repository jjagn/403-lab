clear, clc, close all

%% CHECK DIRECTORY FOR MAT FILES
files = dir("data/3 cart/*.mat");
len = length(files);
% len = 1; % set len to 1 so we don't waste time iterating through all the files when we don't need to
figure()
hold on

% making plots pretty + readable
FontSize = 20;
lineSpecs = ["-";"--";":";"-."];
fontsize(gca, FontSize, 'points')


% for shifting plots around
main_start = 12637;
dur = 8000;
%% MAIN LOOP
for i = 5:len
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
    disp(i)
    disp(i-4)
    lineSpec = lineSpecs(i-4)
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
% title("Reccommended gains for 3-cart system in varying conditions", 'FontSize', FontSize)
plot(time_data(start:end_time), PC(start:end_time), 'Linewidth', 2)
xlim([0, time_data(end_time)])
legend('Original System', 'Weight on cart 2', 'Weight on cart 3', 'Weight on carts 2 & 3', 'Position Command', 'Fontsize', FontSize)
% legend('Cart 3 position')
xlabel('Time [s]', 'FontSize', FontSize)
ylabel('Cart 3 position [m]', 'FontSize', FontSize)
%     legend('Cart 3 position 1', 'Position command 1',...
%         'Cart 3 position 2', 'Position command 2',...
%         'Cart 3 position 3', 'Position command 3',...
%         'Cart 3 position 4', 'Position command 4')