%% ============================================================
%  ESPACIO DE ESTADOS
%  Autor: Jaime Patricio Chiqui Chiqui
%  Universidad de Cuenca - Ingeniería en Telecomunicaciones
% =============================================================

% Limpiar entorno
clc; clear; close all;

% Parámetros del circuito
R = 5;          % Resistencia (ohmios)
L = 0.1;        % Inductancia (henrios)
Cap = 220e-6;   % Capacitancia (faradios)

num = 1/(L * Cap);               % Numerador
den = [1, R/L, 1/(L * Cap)];     % Denominador

Gs = tf(num, den)       % Func. Transferencia

Kp = 100;     % P
Kp2 = 10; Ki2 = 500; % PI
Kp3 = 10; Ki3 = 1000; Kd3 = 0.050;  % PID
% Valores obtenidos con PID Tunner
Kp3 = 16.7573383387027; 
Ki3 = 1762.80242907617; 
Kd3 = 0.0362210629547162;  % PID
