function [bpms] = calculateBpms (...
        wave_resolution,...     % Points in a single ecg wave
        sample_frequency...     % Frecuency at which ecg is recorded
    )
    bpms = (sample_frequency/wave_resolution)*60;
end

