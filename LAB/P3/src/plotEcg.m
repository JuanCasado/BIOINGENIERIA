function plotEcg(...
        multy_ecg_wave,...      % Ecg waves to be ploted
        sample_frequency,...    % Frecuency at which ecg is recorded
        view_width,...          % Number of ecg waves to visualize
        amplitude,...           % Maximun amplitude of the ecg wave
        samples...              % Points in the multy_ecg_wave
    )

    % Create the time scale for the ecg
    sample_period = 1/sample_frequency;
    time_scale = sample_period:sample_period:(samples*sample_period);

    % Plot the ecg
    plot(time_scale,multy_ecg_wave);
    axis([0 view_width -(amplitude+0.5) (amplitude+0.5)]);
    grid;
    xlabel('Time [sec]'); 
    ylabel('Voltage [mV]');
end

