
% Create a new Recording
% Create the object
b = Bitalino;
% Start background acquisition
b.startBackground;
% Pause to acquire data for 20 seconds
disp('Record stating')
pause(10);
disp('Record ended')
% Read the data from the device
data = b.read;

% Stop background acquisition of data
b.stopBackground
% Clean up the bitalino object
delete(b)

%%
% Open an existing recording
load('./measure2/formated_data.txt'); % Comment this line to use live data
ECG_raw = data(:,8);
figure;
plot(ECG_raw);

%%
% Find the peacks

[peaks, x_values] = findpeaks(ECG_raw,'MinPeakHeight', 900);

plot(ECG_raw)
hold on
plot (x_values,peaks,'o')
hold off



