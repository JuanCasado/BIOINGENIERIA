

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




len = length(time_vector);
frequency=fft(ecg)/sqrt(len);
power_time_vector=0.5*sampling_rate*linspace(0,1,floor(len/2)+1);
range=(1:floor(len/2)+1);
power=abs(frequency(range)).^2;
spectrum=frequency.*conj(frequency);

spectrum_len=length(spectrum);
hz=ceil(1/(500/spectrum_len));
low=floor(hz*0.8);
high=hz*440;
diff=spectrum_len-(low+high);
delete=[zeros(low,1); ones(diff,1); zeros(high,1)];

noise=(spectrum<5);
start_seen=false;
end_seen=false;
start_value=0;
end_value=0;
for i=low*2:length(noise)
    if ~start_seen && noise(i)==0
        start_value=i;
        start_seen=true;
    end
    if start_seen && ~end_seen && noise(i)==1
        end_value=i;
        end_seen=true;
    end
end
start_value=start_value-hz*0.8;
end_value=end_value+hz*0.8;
for i=low*2:length(noise)
   if (i>start_value) && (i<end_value)
       delete(i)=0;
   end
end

clean_frecuency=frequency.*(delete);

clean_power=abs(clean_frecuency(range)).^2;
clean_ecg=ifft(clean_frecuency)*sqrt(len);


figure
plot(power_time_vector,power)
xlabel('Frequency (Hz)')
ylabel('power')
title('Signal power');

figure
plot(power_time_vector,clean_power)
xlabel('Frecuencia')
ylabel('clean_power')
title('Signal power cleaned');

figure
plot(time_vector,clean_ecg,'r')
xlabel('Time (s)')
title('Clean ECG');

grid on;

