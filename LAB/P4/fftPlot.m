

function [fss,halfASpect]=fftPlot(tsec,ecg)
% Compute the FFT on the sampled signal
fftSpect=fft(ecg);
% number of samples are
nsamp=length(tsec);
% The fft transform coeffs are simmetric so we take only the half
hindex=ceil(nsamp/2);
halfSpect=zeros(1,hindex);
halfSpect(1:hindex)=(nsamp/2)*fftSpect(1:hindex);
% The frequency intervals are spaced by deltaF
% The fft consider the signal as periodic: in our case the signal last for
% tsec(end) approx 32 seconds
deltaFs=1/tsec(end);
fss=0:deltaFs:(hindex-1)*deltaFs;
halfASpect=abs(halfSpect);
plot(fss,halfASpect);
xlabel('Frequency   (Hz)');
ylabel('FFT magnitude');
end