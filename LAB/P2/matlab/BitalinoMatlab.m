%%
% Create a new Recording

% Create the object
b = Bitalino;
% Start background acquisition
b.startBackground;
% Pause to acquire data for 20 seconds
disp('Record stating')
pause(20);
disp('Record ended')
% Read the data from the device
data = b.read;

% Stop background acquisition of data
b.stopBackground
% Clean up the bitalino object
delete(b)

%%
% Open an existing recording
load('./formated_data.txt'); % Comment this line to use live data
ECG_raw = formated_data(:,8);
figure;
plot(ECG_raw);

%%
% Find the peacks
[peaks, x_values] = findpeaks(ECG_raw,'MinPeakHeight', 800);

plot(ECG_raw,'b-')
hold on
plot (x_values,peaks,'k^','MarkerFaceColor','r')
hold off

%%
% Calculate time intervals and bpms

previous_time = 0;
time_intervals = zeros(1,size(x_values,1));
bpms = zeros(1,size(x_values,1));
for i = 1:size(x_values,1)
    time_interval = (x_values(i) - previous_time)/1000;
    time_intervals(i) =  time_interval;
    bpms(i) = 1/(time_interval/60);
    previous_time = x_values(i);
end

bpm = mean(bpms); time_interval = mean(time_intervals);
bpm_std = std(bpms); time_interval_std = std(time_intervals);
disp(strcat('BPM:  ', num2str(bpm), ' | DESVIACIÓN:  ', num2str(bpm_std)))
disp(strcat('TIME:  ', num2str(time_interval), ' | DESVIACIÓN:  ', num2str(time_interval_std)))

%%
% PLOT BPMS HISTOGRAM

subplot(1,2,1); histogram(bpms, 'BinMethod', 'sturges')
subplot(1,2,2); histogram(time_intervals, 'BinMethod', 'sturges')
%%
% RITMOGRAMA

bar(time_intervals)

%%
% POINCARE

% The first time series is: n0, n1, n2 ...
% The second time series is: n1, n2, n3 ...
X = bpms;
X(end)=[];
Y=bpms;
Y(1)=[];

plot(Y,X,'*b');
hold on
plot(bpms,bpms,'-r');
plot(bpms-bpm_std,bpms,'-k');
plot(bpms+bpm_std,bpms,'-k');
axis([65 85 65 85])
hold off

