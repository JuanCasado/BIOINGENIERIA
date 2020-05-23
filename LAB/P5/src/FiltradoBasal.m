
load ecg500.dat
sampling_rate = 500;                    % Hertz
sampling_period = 1/sampling_rate;      % Seconds
elapsed_time=sampling_period*(length(ecg500)-1);
time_vector = 0:sampling_period:elapsed_time;


figure('Name', 'Original ECG');
plot(time_vector, ecg500)
grid on;


figure('Name', 'FFT Original ECG');
fftPlot(time_vector,ecg500);

figure('Name', 'Wavelet Filter');
clean_ecg = lineabase(ecg500, 'db7', 1);

figure('Name', 'FFT Filtered ECG');
fftPlot(time_vector,clean_ecg);
