clear;
close all;
% Define the file path
filePath = 'C:\Users\Kusha\OneDrive\Desktop\Laboratory course Matlab\EXP 3\VibrationSensorData.xlsx';

% Import the measurement data without any incorrect data
data = readtable(filePath,'Range','B1:C1001');

% Assign the variables xValues and yValues
xValues = data.x;  % Assuming the x-values are in a column named 'x_in_sec'
yValues = data.y;         % Assuming the y-values are in a column named 'y'

% Visualize the signal with a formatted plot
figure;
plot(xValues, yValues, 'color', 'cyan', 'LineWidth', 2);
title('Vibration Measurement Signal');
xlabel('Time');
ylabel('Amplitude');
grid on;
% Example
xValues = 0:0.001:0.999;  % Example vector with supposed equidistance
dx = gradient(xValues);
uniqueDx = unique(dx);
differences = diff(uniqueDx);

disp('Original xValues:');
disp(xValues);
disp('Differences between neighboring unique values:');
disp(differences);
% Calculate the derivative of the xValues vector
dx = gradient(xValues);

% Determine unique values in the resulting vector
uniqueDx = unique(dx);

% Display the number of unique values and their mean value
numUniqueValues = numel(uniqueDx);
meanUniqueValues = mean(uniqueDx);

disp('Number of Unique Values:');
disp(numUniqueValues);

disp('Mean Value of Unique Values:');
disp(meanUniqueValues);
% Convert x values to a vector with simple floating point accuracy
xValuesSimple = single(xValues);

% Calculate the derivative of the simplified xValues vector
dxSimple = gradient(xValuesSimple);

% Determine unique values in the resulting simplified vector
uniqueDxSimple = unique(dxSimple);

% Display the number of unique values and their mean value in the simplified vector
numUniqueValuesSimple = numel(uniqueDxSimple);
meanUniqueValuesSimple = mean(uniqueDxSimple);

disp('Number of Unique Values (Simple Floating Point Accuracy):');
disp(numUniqueValuesSimple);

disp('Mean Value of Unique Values (Simple Floating Point Accuracy):');
disp(meanUniqueValuesSimple);
% Calculate the inverse of the time difference between adjacent values
samplingFrequencyEstimate = 1 / (xValues(2) - xValues(1));

disp('Estimated Sampling Frequency:');
disp(samplingFrequencyEstimate);
% Assuming yValues is the signal you want to analyze
yData = yValues;

% Perform the FFT
fftResult = fft(yData);

% Divide the transformed signal for normalization
normalizedFFT = fftResult / (length(yData)/2);

% Calculate the amplitudes from the complex results of the FFT
amplitudes = abs(fftResult) / length(yData)*2;

% Create the frequency vector
samplingFrequency = 1 / (xValues(2) - xValues(1));
frequency = (0 : length(yData)-1) * samplingFrequency / length(yData);
% Plot the discrete data points in red
figure;
scatter(frequency, amplitudes, 25, 'r', 'filled');
hold on;
% Connect the data points with a blue line
plot(frequency, amplitudes, 'b', 'LineWidth', 2);
% Display the frequencies and corresponding amplitudes
disp('Frequencies (Hz):');
disp(frequency);

disp('Amplitudes:');
disp(amplitudes);
% Plot the FFT result
figure;
plot(frequency, amplitudes, 'LineWidth', 2);
title('FFT of Vibration Measurement Signal');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
grid on;
% Assuming a threshold for dominant frequencies, you can adjust it as needed
threshold = 1;

% Determine the indices of dominant frequencies using logical indexing
dominantIndices = amplitudes > threshold

disp('Indices of Dominant Frequencies:');
disp(dominantIndices);
% Create a new complex frequency vector with dominant frequencies
cleanedFrequencyVector = complex(zeros(1000,1));
cleanedFrequencyVector(dominantIndices) = fftResult(dominantIndices);
% Transform the cleaned complex frequency vector back into the time domain
cleanedSignal = ifft(cleanedFrequencyVector,length(yData));
% Visualize the result and compare with the original signal
figure;
plot(xValues, yValues, 'r', 'LineWidth', 2, 'DisplayName', 'Original Signal');
hold on;
plot(xValues, real(cleanedSignal), 'b', 'LineWidth', 2, 'DisplayName', 'Cleaned Signal');
title('Comparison of Original and Cleaned Signals');
xlabel('Time');
ylabel('Amplitude');
legend('show');
grid on;
hold off;
