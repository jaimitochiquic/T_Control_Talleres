clc, clear all, close all;

% Parametros Actividad Reto (Pasa altas)
R = 100;          
L = 112.54e-3;    
C = 22.5e-6;    

% Funcion de transferencia RLC (inductor)
num = [1 0 0]; 
den = [1 R/L 1/(L*C)];
G = tf(num, den)
%% Graficamos el D. Bode comandos Matlab
N = 100;
w = logspace(1,7,N);
bode(G,w);
grid on;
title('Diagrama de Bode - Función bode()');

% Función de transferencia: Salida en Inductor (Pasa Altas)
s = 1j * w;  % s = jω
G_jw = (s.^2) ./ (s.^2 + (R/L)*s + 1/(L*C));

% Calcular magnitud en decibeles
magnitud_lineal = abs(G_jw);             % Magnitud en valor absoluto
magnitud_dB = 20*log10(magnitud_lineal); % Magnitud en decibeles [dB]

% Calcular fase en grados
fase_rad = angle(G_jw);                 % Fase en radianes
fase_grados = fase_rad * (180/pi);      % Fase en grados [°]

% Convertir frecuencia a Hertz
f_Hz = w / (2*pi);               % Frecuencia en Hertz [Hz]

% Gráfica de Magnitud en Hz
figure(); subplot(2,1,1);
semilogx(f_Hz, magnitud_dB, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Magnitud (dB)');
title('Diagrama de Bode Manual en Hz - Magnitud');

% Gráfica de Fase en Hz
subplot(2,1,2)
semilogx(f_Hz, fase_grados, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia (Hz)');
ylabel('Fase (grados)');
title('Diagrama de Bode Manual en Hz - Fase');

