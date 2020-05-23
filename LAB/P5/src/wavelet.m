function [detalle,aproxim] = wavelet(origen,wave,nivel)
    [C,L]=wavedec(origen,nivel,wave);
    aproxim=wrcoef('a',C,L,wave,nivel);
    detalle=wrcoef('d',C,L,wave,nivel);
end

