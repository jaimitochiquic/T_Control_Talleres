clc; clear; close all;

% Parámetros del circuito 
R1 = 10e3;
C1 = 1e-12;
R2 = 10e3;
C2 = 1e-6;
R3 = 10e3;
R4 = 10e3;

% Parametros para Actividad en clase (Comparar con LTSPICE)
R1 = 10e3;
C1 = 1e-12;
R2 = 10e3;
C2 = 1e-6;
R3 = 10e3;
R4 = 10e3;

%%%%%%%%%%%Versión manual del diagrama de Bode
% Numerador y denominador de la función de transferencia
num = [R4 * R2 * R1 * C1, R4 * R2];
den = [R3 * R1 * R2 * C2, R3 * R1];
G = tf(num, den)

% Crear el vector de frecuencias (rad/s)
N = 100;
w = logspace(1, 9, N);   % de 10^1 a 10^9 rad/s
f = w / (2*pi);          % conversión a Hz

% Evaluación en s = jω
s = 1i * w;
H = (num(1) * s + num(2)) ./ (den(1) * s + den(2));  % G(jω) = (b1*s + b0) / (a1*s + a0)

% Cálculo de magnitud y fase
mag = abs(H);                % Magnitud lineal
mag_dB = 20 * log10(mag);    % Magnitud en dB
fase = angle(H);             % Fase en radianes
fase_deg = fase * (180/pi);  % Fase en grados

% Gráfica de Bode (manual)
figure();
subplot(2,1,1);
semilogx(f, mag_dB, 'b', 'LineWidth', 1.5);
grid on;
ylabel('Magnitud (dB)');
title('Diagrama de Bode Manual');

subplot(2,1,2);
semilogx(f, fase_deg, 'r', 'LineWidth', 1.5);
grid on;
ylabel('Fase (°)');
xlabel('Frecuencia (Hz)');

figure(2)
G = tf(num,den);
[mag, phase, wout] = bode(G, w);

mag = squeeze(mag);
phase = squeeze(phase);

subplot(2,1,1)
semilogx(wout, 20*log10(mag), 'LineWidth', 2)
grid on
title('Diagrama de Bode (RLC) en rad/s')
ylabel('Magnitud (dB)')

subplot(2,1,2)
semilogx(wout, phase, 'LineWidth', 2)
grid on
ylabel('Fase (grados)')
xlabel('Frecuencia (rad/s)')


%% Graficamos el D. Bode comandos Matlab
figure()
N = 100;
w = logspace(1,7,N);
bode(tf(num,den),w);
grid on;
title('Diagrama de Bode - Función bode()');


