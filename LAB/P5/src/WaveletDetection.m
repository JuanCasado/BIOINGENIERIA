
[samples_original, sampling_frecuency_original, data_original]=loadATM('rec_2m',1);
[samples_filterd, sampling_frecuency_filtered, data_filtered]=loadATM('rec_2m',2);

sampling_period = 1/sampling_frecuency_filtered;
elapsed_time=sampling_period*(samples_filterd-1);
time_vector = 0:sampling_period:elapsed_time;

ecg=data_filtered;

%% QRS
[detalle1,aprox1]=wavelet(ecg, 'coif3', 1);
[detalle4,aprox4]=wavelet(ecg, 'coif3', 4);

QRS=(ecg-aprox4)-detalle1;

figure('Name', 'QRS');
subplot(2,1,1);plot(QRS);
subplot(2,1,2);plot(ecg);

%% T
[detalle7,aprox7]=wavelet(ecg, 'coif3', 7);
[detalle9,aprox9]=wavelet(ecg, 'coif3', 9);

T=aprox7-aprox9;

figure('Name', 'T');
subplot(2,1,1);plot(T);
subplot(2,1,2);plot(ecg);

 
%% P
[detalle6,aprox6]=wavelet(ecg, 'coif3', 6);
P=detalle6;

figure('Name', 'P');
subplot(2,1,1);plot(P);
subplot(2,1,2);plot(ecg);


%% ECG

figure('Name', 'ECG')
subplot(2,1,1);
plot(time_vector,data_original);
title('Original ECG')
subplot(2,1,2);
plot(time_vector,data_filtered);
title('Original ECG')

figure('Name', 'FFT original')
fftPlot(time_vector,data_original);
figure('Name', 'FFT filtered')
fftPlot(time_vector,data_filtered);

%% 50 Hz noise

[detalle50_2,aprox50_2]=wavelet(data_original, 'sym8', 2);
[detalle50_3,aprox50_3]=wavelet(data_original, 'sym8', 3);

figure('Name', '50 HZ noise 2');
subplot(4,1,1);plot(detalle50_2);title('Detalle  2');
subplot(4,1,2);fftPlot(time_vector,detalle50_2);title('FFT Detalle  2');
subplot(4,1,3);plot(aprox50_2);title('Aproximación  2');
subplot(4,1,4);fftPlot(time_vector,aprox50_2);title('FFT Aproximación  2');

figure('Name', '50 HZ noise 3');
subplot(4,1,1);plot(detalle50_3);title('Detalle  3');
subplot(4,1,2);fftPlot(time_vector,detalle50_3);title('FFT Detalle  3');
subplot(4,1,3);plot(aprox50_3);title('Aproximación  3');
subplot(4,1,4);fftPlot(time_vector,aprox50_3);title('FFT Aproximación  3');

