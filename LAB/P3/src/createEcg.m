
function [multy_ecg_wave, ecg_waves] = createEcg( ...
        wave_resolution,...     % Points in a single ecg wave
        amplitude,...           % Maximun amplitude of the ecg wave
        samples,...             % Points in the multy_ecg_wave
        roundness,...
        offset...
    )
    if nargin < 4
        roundness = 21;
    end
    ecg_waves = samples/wave_resolution;    % Number of beaps in the multy_ecg_wave

    % Obtain a random offset from which to start taking ecg data
    if nargin < 5
        offset = round(wave_resolution*rand(1));
    end
    % Calculate the number of waves to be created to have enough data
    num_ecg_waves = ceil((samples + offset)/ wave_resolution);

    % Create a single wave, smooth it, replicate it and trim it following the configuration
    single_ecg_wave = amplitude*ecg(wave_resolution);
    full_ecg_wave = sgolayfilt(kron(ones(1, num_ecg_waves), single_ecg_wave), 0, roundness);
    multy_ecg_wave = full_ecg_wave((1:samples) + offset);
end

