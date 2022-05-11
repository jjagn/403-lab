clear, clc, close all

files = dir("data/3 cart/*.mat");
len = length(files);

for i = 1:len
    filename = convertCharsToStrings(strcat([files(i).folder '/' files(i).name])); 
    data = load(filename);
    name = cell2mat(fieldnames(data));
    data = data.(name);

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
    
    fprintf('P Gain 1: %f \n', C1P_GAIN)
    fprintf('V Gain 1: %f \n', C1V_GAIN)

    fprintf('P Gain 2: %f \n', C2P_GAIN)
    fprintf('V Gain 2: %f \n', C2V_GAIN)

    fprintf('P Gain 3: %f \n', C3P_GAIN)
    fprintf('V Gain 3: %f \n', C3V_GAIN)
    
    figure()
    plot(time_data, [C1P' C1V' C2P' C2V' C3P' C3V' CMV' PC' RMV'])
    title(convertCharsToStrings(name))
    legend('p1', 'v1', 'p2', 'v2', 'p3', 'v3', 'commanded voltage', 'commanded position', 'raw motor voltage')
end