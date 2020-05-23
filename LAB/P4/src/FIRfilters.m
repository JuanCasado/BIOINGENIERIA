

% Measuring device parameters
sampling_rate = 1000;                   % Hertz
sampling_period = 1/sampling_rate;      % Seconds
adc_binary_resolution = 12;             % Binary digits
v_min = -4.096;                         % Volts
v_max = 4.096;                          % Volts
gain = 1000;                            % How much the ECG was amplified
adc_resolution = (v_max-v_min)/(2^adc_binary_resolution); % Volts


load ecg1ms.dat                         % Captured ECG (ecg1ms)

% The original ECG is reconstructed using the measuring device parameters
ecg = (ecg1ms(:,2).*adc_resolution+v_min)./gain.*1000; %(Last factor converts from Volts to mVolts)
% The ideal time stamps based on the sampling period are also reconstructed 
elapsed_time = (ecg1ms(end,1) - ecg1ms(1,1))*sampling_period;
time_vector = 0:sampling_period:elapsed_time;


%% Plot Results
figure ('Name', 'ECG');

subplot(3,1,1);
plot (ecg1ms (:,2));
title ('Captured ECG (Raw data)');
grid on;

subplot(3,1,2);
plot(time_vector,ecg)
xlabel('Time (seconds)');
ylabel(' ECG (mV)');
title ('Original ECG');
grid on;

subplot(3,1,3);
hold on
[fss,halfASpect] = fftPlot(time_vector,ecg);

% Calculate and plot peaks of fft
[peaks, peaks_time] = findpeaks (halfASpect, 'MinPeakHeight', 2e7);
ffs_peaks = zeros(1, length(peaks_time));
for i = 1:length(peaks_time)
    ffs_peaks(i) = fss(peaks_time(i));
end
plot (ffs_peaks, peaks,'k^','MarkerFaceColor','r')

title ('FFT Monolateral');
grid on;
hold off

%% STOP 50Hz FIR filter
half_sampling_rate = sampling_rate/2;
wl = 48/half_sampling_rate;
wh = 51/half_sampling_rate;
stop50 = fir1 (1536, [wl wh], 'stop');
ecgno50 = filter(stop50, 1, ecg);

%% Plot filtered
figure ('Name', 'Filtered ECG');

subplot(3,1,1);
plot(time_vector, ecgno50, 'r');
title('ECG without 50 Hz noise');
xlabel('Time (seconds)'); 
ylabel('ECG (mV)');
grid on

subplot(3,1,2);
hold on
[fssno50,halfASpectno50] = fftPlot(time_vector, ecgno50);

% Calculate and plot peaks of fftno50
[peaksno50, peaks_timeno50] = findpeaks (halfASpectno50, 'MinPeakHeight', 2e7);
ffs_peaksno50 = zeros(1, length(peaks_timeno50));
for i = 1:length(peaks_timeno50)
    ffs_peaksno50(i) = fssno50(peaks_timeno50(i));
end
plot (ffs_peaksno50, peaksno50,'k^','MarkerFaceColor','r')

title('FFT of filtered ECG')
grid on
hold off

fft_difference = halfASpect - halfASpectno50;

subplot(3,1,3);
hold on
plot(fssno50, fft_difference)

% Calculate and plot peaks of fft_difference
[peaks_diff, peaks_time_diff] = findpeaks (fft_difference, 'MinPeakHeight', 2e7);
ffs_peaks_diff = zeros(1, length(peaks_time_diff));
for i = 1:length(peaks_time_diff)
    ffs_peaks_diff(i) = fssno50(peaks_time_diff(i));
end
plot (ffs_peaks_diff, peaks_diff,'k^','MarkerFaceColor','r')

title(strcat('FFT Difference (max:  ', num2str(peaks_diff(1)),')'))
grid on
hold off

%% Frezqz Analisis
figure ('Name', 'Freqz no 50Hz');
freqz(ecgno50)

stop50_2 = fir1 (2048, [wl wh], 'stop');
ecgno50_2 = filter(stop50_2, 1, ecg);


figure ('Name', 'Filtered ECG 2');

subplot(3,1,1);
plot(time_vector, ecgno50_2, 'r');
title('ECG without 50 Hz noise');
xlabel('Time (seconds)'); 
ylabel('ECG (mV)');
grid on

subplot(3,1,2);
hold on
[fssno50_2,halfASpectno50_2] = fftPlot(time_vector, ecgno50_2);

% Calculate and plot peaks of fftno50
[peaksno50_2, peaks_timeno50_2] = findpeaks (halfASpectno50_2, 'MinPeakHeight', 2e7);
ffs_peaksno50_2 = zeros(1, length(peaks_timeno50_2));
for i = 1:length(peaks_timeno50_2)
    ffs_peaksno50_2(i) = fssno50(peaks_timeno50_2(i));
end
plot (ffs_peaksno50_2, peaksno50_2,'k^','MarkerFaceColor','r')

title('FFT of filtered ECG')
grid on
hold off

fft_difference_2 = halfASpect - halfASpectno50_2;

subplot(3,1,3);
hold on
plot(fssno50_2, fft_difference_2)

% Calculate and plot peaks of fft_difference
[peaks_diff_2, peaks_time_diff_2] = findpeaks (fft_difference_2, 'MinPeakHeight', 2e7);
ffs_peaks_diff_2 = zeros(1, length(peaks_time_diff_2));
for i = 1:length(peaks_time_diff_2)
    ffs_peaks_diff_2(i) = fssno50_2(peaks_time_diff_2(i));
end
plot (ffs_peaks_diff_2, peaks_diff_2,'k^','MarkerFaceColor','r')

title(strcat('FFT Difference (max:  ', num2str(peaks_diff_2(1)),')'))
grid on
hold off

figure ('Name', 'Freqz no 50Hz 2');
freqz(ecgno50_2)

%% Delete DC with highpass filter

highpass = fir1(2000, 1/half_sampling_rate, 'high');
ecgnoDC = filter(highpass, 1, ecgno50);

%% Plot results DC filter

figure ('Name', 'Firter DC');
subplot(3,1,1)
plot(time_vector, ecgnoDC, 'r');
title('ECG with DC filtered');
xlabel('Time (seconds)');
ylabel('ECG (mV)');
grid on

subplot(3,1,2)
hold on
[fssnoDC, halfASpectnoDC] = fftPlot(time_vector,ecgnoDC);

% Calculate and plot peaks of fft
[peaksnoDC, peaks_timenoDC] = findpeaks (halfASpectnoDC, 'MinPeakHeight', 1e7);
ffs_peaksnoDC = zeros(1, length(peaks_timenoDC));
for i = 1:length(peaks_timenoDC)
    ffs_peaksnoDC(i) = fss(peaks_timenoDC(i));
end
plot (ffs_peaksnoDC, peaksnoDC,'k^','MarkerFaceColor','r')

title('FFT of DC filtered')
grid on
hold off

fft_dcdiff = halfASpectno50 - halfASpectnoDC;

subplot(3,1,3)
plot (fssnoDC, fft_dcdiff)
title('FFT difference')
grid on

%% Delete high frec with lowpass filter

lowpass = fir1(20, 1/half_sampling_rate, 'low');
ecgClean = filter(lowpass, 100, ecgnoDC);

%% Plot results DC filter

figure ('Name', 'ECG clean');
subplot(3,1,1)
plot(time_vector, ecgClean, 'r');
title('ECG clean');
xlabel('Time (seconds)');
ylabel('ECG (mV)');
grid on

subplot(3,1,2)
[fssClean, halfASpectClean] = fftPlot(time_vector,ecgClean);
title('FFT of ECCG clean')
grid on

fft_Cleandiff = halfASpectnoDC - halfASpectClean;

subplot(3,1,3)
plot (fssClean, fft_Cleandiff)
title('FFT difference')
grid on







