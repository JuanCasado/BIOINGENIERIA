

global numero_promedios ecg_promediado latido_ecg t current_error acc_error

numero_promedios = 0;
ecg_promediado = [];
current_error = [];
acc_error = [];
% Generamos un latido QRS con 2700 muestras de resolución y amplitud 3.5.
X = 3.5*ecg(2700);
% Smooth ECG
latido_ecg = sgolayfilt(kron(ones(1, 1), X), 0, 31);


% Crete the figure where data will be plotted (on window closed timer is cleared)
figure('Name', 'ECG promediado', 'CloseRequestFcn',@clear_timer);
% On timer period window is updated
t = timer('TimerFcn',{@promedio_call_back}, 'Period', 1); 
set(t,'ExecutionMode','fixedRate');
start(t)


% Created new ECG and Updates the window with it
function promedio_call_back(~,~)
    global numero_promedios ecg_promediado latido_ecg current_error acc_error
    numero_promedios = numero_promedios + 1;
    
    SNR=1;
    ecg_ruidoso = awgn(latido_ecg, SNR,'measured','linear');
    current_error = [current_error sum(abs(latido_ecg - ecg_ruidoso))];
    
    %Acumulamos ecg_ruidoso en ecg_promediado:
    ecg_promediado = [ecg_promediado; ecg_ruidoso];
    promediado = mean(ecg_promediado);
    acc_error = [acc_error sum(abs(latido_ecg - promediado))];
    
    % PLOT ECGs
    subplot(2,2,1);
    plot(ecg_ruidoso);
    title(strcat('Latido ECG ruidoso con SNR=',num2str(SNR)));
    subplot(2,2,3);
    plot(promediado);
    title(strcat('Señal promediada #',num2str(numero_promedios)));
    subplot(2,2,2);
    plot(current_error);
    title(strcat('Error Actual=', num2str(current_error(end))));
    subplot(2,2,4);
    plot(acc_error);
    title(strcat('Error acumulado=', num2str(acc_error(end))));
end

% Clears timer and window
function clear_timer(~,~)
    global t
    stop(t)
    delete(t)
    delete(gcf)
end
