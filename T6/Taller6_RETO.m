%==========================================================================
%   Taller 6: Análisis de Estabilidad (Routh-Hurwitz) en MATLAB
%==========================================================================
clc; clear; close all;

% --- Parámetros del Circuito RLC (Taller 5) ---
R = 5;       % Resistencia (Ohmios)
L = 0.1;     % Inductancia (Henrios)
C = 220e-6;  % Capacitancia (Faradios)
% Parámetros PID Sintonizados (PID Tuner) ---
Kp = 16.7573;
Ki = 1762.8024;
Kd = 0.03622;
N  = 6402.7121;

% Función de Transferencia de la Planta (G_p(s)) ---
% Gp(s) = A / (s^2 + (R/L)s + A), donde A = 1/(L*C)
A = 1 / (L * C);
Num_p = A;
Den_p = [1, R/L, A];
disp('Funcion de Transferencia de la Planta G_p(s):');
G_RLC = tf(Num_p, Den_p)

% Función de Transferencia del Controlador (G_c(s))
% Gc(s) = Kp + Ki/s + Kd * (N*s / (s + N))
Num_c = [ (Kd*N + Kp), (Kp*N + Ki), (Ki*N) ];
Den_c = [1, N, 0]; % s*(s+N) = s^2 + Ns + 0
disp('Funcion de Transferencia del Controlador Filtrado G_c(s):');
CPID = tf(Num_c, Den_c)

% Sistema en Lazo Cerrado (Gcl) ---
% Gcl = Gc(s) * Gp(s) / (1 + Gc(s) * Gp(s))
Serie = series(CPID, G_RLC);
disp('Funcion de Transferencia del Sistema en Lazo Cerrado G_CL(s):');
Gcl = feedback(Serie, 1)  % Realimentacion unitaria H=1

% Análisis de Estabilidad ---
[Num_cl, Den_cl] = tfdata(Gcl, 'v');

% Hallar los Polos (raíces de P(s))
disp('Ubicacion de los Polos (Raices del Polinomio Caracteristico):');
p = pole(Gcl)

% Verificar estabilidad: si todos los polos tienen parte real negativa, es estable.
Real_Part = real(p);
if all(Real_Part < 0)
    disp('=> El sistema es ESTABLE (Todos los polos estan en el semiplano izquierdo).');
else
    disp('=> El sistema es INESTABLE (Al menos un polo esta en el semiplano derecho o sobre el eje imaginario).');
end

% --- 7. Gráficas de Análisis ---
figure(); step(Gcl); % Respuesta al escalon
title('Respuesta al Escalón del Sistema RLC con PID Filtrado');
grid on;
figure(); pzmap(Gcl); % Diagrama de polos y ceros
title('Diagrama de Polos y Ceros del Sistema en Lazo Cerrado');
grid on;