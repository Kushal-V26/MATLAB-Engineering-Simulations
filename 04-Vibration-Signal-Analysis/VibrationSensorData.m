% Clear the workspace and command window
clear; 
clc;

% Define the filename (ensure it matches the uploaded file exactly)
filename = 'VibrationSensorData.xlsx'; 

% Import the measurement data
% Use readtable to load the data into the workspace
data = readtable(filename); 

% Alternatively, if your file has no headers, use column indices:
% xValues = data{:, 1}; 
% yValues = data{:, 2};
