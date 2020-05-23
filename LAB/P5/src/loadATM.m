function [samples, sampling_frecuency, data]=loadATM(Name, index)

    infoName = strcat(Name, '.info');
    matName = strcat(Name, '.mat');
    load(matName);
    fid = fopen(infoName, 'rt');
    fgetl(fid);
    fgetl(fid);
    fgetl(fid);
    [freqint] = sscanf(fgetl(fid), 'Sampling frequency: %f Hz  Sampling interval: %f sec');
    interval = freqint(2);
    fgetl(fid);

    for i = 1:size(val, 1)
      [row(i), signal(i), gain(i), base(i), units(i)]=strread(fgetl(fid),'%d%s%f%f%s','delimiter','\t');
    end

    fclose(fid);
    val(val==-32768) = NaN;

    for i = 1:size(val, 1)
        val(i, :) = (val(i, :) - base(i)) / gain(i);
    end

    sampling_frecuency = freqint(1);
    samples = size(val,2);
    data = val(index,1:size(val,2));
end

