%Esta función está especialmente diseñada para filtrar las variaciones de la línea base
%de una señal ECG. Su sintaxis es:
%filtrada=lineabase(origen,'wave',nivel)
%donde:
%     origen: señal de entrada a ser filtrada.
%     wave: nombre corto de la onda wavelet utilizada para la descomposici�n (p.ej.: haar,
%           db7, bior3.9, sym6, coif5, dmey, rbio6.8, etc)
%     nivel: nivel máximo de descomposición del que se utilizará la aproximaxión para el
%            posterior filtrado por sustracción.
%     filtrada: se�al obtenida tras el filtrado paso alto wavelet. Es la resultante de
%               restar a la se�al origen la señal obtenida de la aproximaci�n wavelet
%               al nivel especificado por el parámetro nivel.
%Tambi�n se plotean los resultados obtenidos.

function [filtrada, aproxim]=lineabase(origen,wave,nivel)

[C,L]=wavedec(origen,nivel,wave);
aproxim=wrcoef('a',C,L,wave,nivel);
filtrada=origen-aproxim;

figure('Name', 'Wavelets')
subplot(3,1,1);plot(origen);title('Señal original');
subplot(3,1,2);plot(filtrada);title(strcat('Detalle  ', num2str(nivel)));
subplot(3,1,3);plot(aproxim);title(strcat('Aproximación  ', num2str(nivel)));
%axis([0 size(origen,1) min(origen) max(origen)]);
