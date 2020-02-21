
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
ECG_raw = formated_data(:,8);
figure;
plot(ECG_raw);

%%
% Find the peacks

[peaks, x_values] = findpeaks(ECG_raw,'MinPeakHeight', 800);

plot(ECG_raw)
hold on
plot (x_values,peaks,'o')
hold off

%%
% Calculate time intervals

previous_time = 0;
time_intervals = [];
for i = 1:size(x_values,1)
   time_intervals = [time_intervals, x_values(i) - previous_time];
   previous_time = x_values(i);
end

%%
hist(time_intervals)
%%
bar (time_intervals)


