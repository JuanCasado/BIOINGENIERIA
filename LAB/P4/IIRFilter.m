

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


half_sampling_rate=sampling_rate/2;


hig_pass=0.001/half_sampling_rate;
N1=1;
[a1,b1] = butter(N1, hig_pass,'high');
ecg_1=filter([a1,b1],1,ecg);


low_pass=100/half_sampling_rate;
N2=10;
[a2,b2]=butter(N2,low_pass); 
ecg_2=filter([a2,b2],1,ecg);


start_cut=48/half_sampling_rate;
end_cut=51/fm3e;
N3=1;
[a3,b3]=butter(N3,[start_cut,end_cut],'stop'); 
ecg_3=filter([a3,b3],1,ecg);




figure(1) 
freqz(a1,b1)

figure(2)
plot(time_vector, ecg_1)

figure(3) 
freqz(a2,b2);

figure(4)
plot(time_vector, ecg_2)

figure(5) 
freqz(a3,b3);

figure(6)
plot(time_vector, ecg_3)


