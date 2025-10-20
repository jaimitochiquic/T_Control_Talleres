%% ============================================================
%  Taller 2 - Respuesta de un sistema a señales arbitrarias
%  Autor: Jaime Patricio Chiqui Chiqui
%  Universidad de Cuenca - Ingeniería en Telecomunicaciones
% =============================================================

% Limpiar entorno
clc; clear; close all;

%% ============================================================
% 1. Definición de la función de transferencia base
% ============================================================
num = [3];       % Numerador de la función de transferencia
den = [1 2 3];   % Denominador de la función de transferencia
ts  = 0.1;       % Tiempo de muestreo [s]

Gs = tf(num, den);           % Sistema continuo
Gz = tf(num, den, ts);       % Sistema discreto equivalente

delay = 2;                   % Retardo en segundos
Gs_delay = tf(num, den, 'InputDelay', delay);

%% ============================================================
% 2. Respuesta a señales típicas: impulso y escalón
% ============================================================

figure;
impulse(Gs);
title('Respuesta al Impulso de G(s)');
xlabel('Tiempo [s]'); ylabel('Amplitud');
grid on; drawnow;

figure;
step(Gs);
title('Respuesta al Escalón de G(s)');
xlabel('Tiempo [s]'); ylabel('Amplitud');
grid on; drawnow;

%% ============================================================
% 3. Almacenamiento en vectores y análisis de la respuesta
% ============================================================

[y, t] = step(Gs);  % Almacenar respuesta y tiempo

figure;
plot(t, y, 'LineWidth', 1.5);
grid on;
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Respuesta al Escalón de G(s) usando vectores');
drawnow;

%% ============================================================
% 4. Sistema con retardo (tiempo muerto)
% ============================================================
[y1, t1] = impulse(Gs_delay);
[y2, t2] = step(Gs_delay);

figure;
plot(t1, y1, 'b', 'LineWidth', 1.5);
title('Respuesta al Impulso de G(s) con Retardo');
xlabel('Tiempo [s]'); ylabel('Amplitud');
grid on; drawnow;

figure;
plot(t2, y2, 'b', 'LineWidth', 1.5); hold on;
title('Respuesta al Escalón de G(s) con Retardo');
xlabel('Tiempo [s]'); ylabel('Amplitud');
grid on; drawnow;

% ============================================================
% 4.1. Sistema con retardo con marcadores máximo
% ============================================================

% Encontrar máximos
[max_val, idx] = max(y1);
t_max = t1(idx);   % Tiempo del máximo en impulso

[max_val2, idx2] = max(y2);
t_max2 = t2(idx2); % Tiempo del máximo en escalón

figure(); % --- Figura impulso con retardo + punto máximo
plot(t1, y1, 'b', 'LineWidth', 1.5); hold on;
plot(t_max, max_val, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Respuesta al Impulso con Retardo (punto máximo)');
xlabel('Tiempo [s]'); ylabel('Amplitud');
grid on;

figure(); % --- Figura escalón con retardo + punto máximo
plot(t2, y2, 'b', 'LineWidth', 1.5); hold on;
plot(t_max2, max_val2, 'ro', 'MarkerSize', 8, 'LineWidth', 2);
title('Respuesta al Escalón con Retardo (punto máximo)');
xlabel('Tiempo [s]'); ylabel('Amplitud');
grid on;

%% ============================================================
% 5. Respuesta a señal arbitraria personalizada
% ============================================================

% 5.1a señal de excitación arbitraria guia
% ============================================================
t_g = 0:0.1:30;   % Dimension de la grafica
signal = zeros(size(t_g));
%Condiciones por tramos
signal(t_g >= 10 & t_g < 20) = 5;
signal(t_g >= 20) = 10;

figure(); % Grafica
plot(t_g, signal, 'b--', 'LineWidth', 2);
title('Señal arbitraria dada'); grid on;
xlabel('Tiempo [s]'); ylabel('Amplitud');

% 5.1b señal de excitación arbitraria guia
% ============================================================
% --- Respuesta del sistema a la señal arbitraria
[y_arb, tt_arb] = lsim(Gs, signal, t_g);

figure;
plot(tt_arb, y_arb, ...
    t_g, signal, 'LineWidth', 1.8);
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Respuesta del Sistema a Señal excitación Arbitraria');
grid on; drawnow;


% 5.3 señal de excitación arbitraria guia
% ============================================================
t_arb = 0:0.1:40;               % Vector de tiempo [s]
u_arb = zeros(size(t_arb));     % Inicializar señal

% --- Tramo 1: 0 <= t < 10 → u = 0
u_arb(t_arb >= 0 & t_arb < 10) = 0;
% --- Tramo 2: 10 <= t < 20 → u = 5
u_arb(t_arb >= 10 & t_arb < 20) = 5;
% --- Tramo 3: 20 <= t < 30 → Rampa de 15 a 25
idx = (t_arb >= 20 & t_arb < 30);
u_arb(idx) = linspace(15, 25, sum(idx));  % Δ calculado automáticamente
% --- Tramo 4: t >= 30 → u = 25
u_arb(t_arb >= 30) = 25;

% --- Graficar señal arbitraria
figure;
plot(t_arb, u_arb, '--', 'LineWidth', 2);
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal Arbitraria por Tramos');
grid on; drawnow;

% --- Graficar señal arbitraria + respuesta
[y_arb2, tt_arb2] = lsim(Gs, u_arb, t_arb);

figure;
plot(t_arb, u_arb, '--', ...
    tt_arb2, y_arb2, 'LineWidth', 2);
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Respuesta a una Señal Arbitraria por Tramos');
grid on; drawnow;

%% ============================================================
% 6. Actividad Reto: Señal PRBS Combinada
% ============================================================

% 6.1 Señal PRBS Combinada aleatoria
% ============================================================
t_prbs = 0:0.1:40;              % Vector de tiempo [s]
u_prbs = zeros(size(t_prbs));   % Inicializar señal PRBS

% --- Tramo 1: 0 <= t < 10 → Sinusoidal
idx1 = (t_prbs >= 0 & t_prbs < 10);
u_prbs(idx1) = sin(2*pi*0.25*t_prbs(idx1));  % Frecuencia 0.25 Hz

% --- Tramo 2: 10 <= t < 15 → Escalón (valor 3)
idx2 = (t_prbs >= 10 & t_prbs < 15);
u_prbs(idx2) = 3;

% --- Tramo 3: 15 <= t < 20 → Rampa ascendente (3 a 5)
idx3 = (t_prbs >= 15 & t_prbs < 20);
u_prbs(idx3) = linspace(3, 5, sum(idx3));

% --- Tramo 4: 20 <= t < 25 → Escalón (valor 5)
idx4 = (t_prbs >= 20 & t_prbs < 25);
u_prbs(idx4) = 5;

% --- Tramo 5: 25 <= t < 30 → Rampa descendente (5 a -3)
idx5 = (t_prbs >= 25 & t_prbs < 30);
u_prbs(idx5) = linspace(5, -3, sum(idx5));

% --- Tramo 6: t >= 30 → Escalón de bajada (-3)
idx6 = (t_prbs >= 30);
u_prbs(idx6) = -3;

% --- Gráfica de señal PRBS
figure;
plot(t_prbs, u_prbs, 'LineWidth', 1.5); hold on;
xlabel('Tiempo [s]');
ylabel('Amplitud');
title('Señal PRBS Combinada Aleatoria');
grid on; drawnow;

% --- Respuesta del sistema PRBS con retardo
y_prbs = lsim(Gs_delay, u_prbs, t_prbs);

% 6.2 Señal PRBS Combinada aleatoria + respuesta
% ============================================================
% --- Gráfica de señal PRBS y respuesta
figure;
plot(t_prbs, u_prbs, 'LineWidth', 1.5); hold on;
plot(t_prbs, y_prbs, 'LineWidth', 2);
xlabel('Tiempo [s]'); ylabel('Amplitud');
title('Señal PRBS Combinada y Respuesta del Sistema con Retardo');
legend('Entrada PRBS', 'Salida del Sistema', 'Location', 'best');
grid on; drawnow;