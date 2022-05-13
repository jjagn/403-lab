clear, clc, close all

%% CHECK DIRECTORY FOR MAT FILES
files = dir("data/3 cart/*.mat");
% len = length(files);
len = 1; % set len to 1 so we don't waste time iterating through all the files when we don't need to

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
    fprintf('V Gain 1: %f \n', C1V_GAIN)

    fprintf('P Gain 2: %f \n', C2P_GAIN)
    fprintf('V Gain 2: %f \n', C2V_GAIN)

    fprintf('P Gain 3: %f \n', C3P_GAIN)
    fprintf('V Gain 3: %f \n', C3V_GAIN)

    fprintf('\n\n\n')
    
    %% PLOT FIGURES

    % position plot
    figure()
    plot(time_data, [C1P' C2P' C3P' PC'])
    title(strcat([name_str "position"]))
    legend('p1', 'p2', 'p3', 'commanded position')

    % voltage plot
    figure()
    voltage_diff = CMV-RMV;
    plot(time_data, [RMV' CMV'])
    yyaxis right
    plot(time_data, voltage_diff')
    title(strcat([name_str "commanded vs raw voltage"]))
    legend('raw motor voltage', 'commanded voltage', 'difference')
end