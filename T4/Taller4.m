%% ============================================================
%  ESPACIO DE ESTADOS
%  Autor: Jaime Patricio Chiqui Chiqui
%  Universidad de Cuenca - Ingeniería en Telecomunicaciones
% =============================================================
% Limpiar entorno
clc; clear; close all;

% Parámetros del circuito
R = 100;    % Resistencia (ohmios)
L = 0.1;    % Inductancia (henrios)
Cap = 1e-6; % Capacitancia (faradios)

%% Matriz de estados de la Guia
A = [0 1; -1/(L*Cap) -R/L]; % Matriz de Estado
B = [0; 1/L];               % Matriz de Entrada
C = [1/Cap 0];              % Matriz de Salida
D = 0;                      % Matriz de Transferencia directa

sys = ss(A,B,C,D);
figure();
subplot(2,1,1);
step(sys);
xlabel('Time [s]'); ylabel('Vc [V]');grid on;

subplot(2,1,2);
impulse(sys);
xlabel('Time [s]'); ylabel('Vc [V]');grid on;
sgtitle("Grafica de la guia");

%% Resuelto en clase
    % x1 = i(t);   x2 = V_c(t)
% Matriz de estados 
A1 = [-R/L -1/L; 1/Cap 0];   % Matriz de Estado
B1 = [1/L; 0];               % Matriz de Entrada
C1 = [0 1; 1 0];             % Matriz de Salida: [v_c; i]
D1 = 0;                      % Matriz de Transferencia directa

sys1 = ss(A1,B1,C1,D1);
figure();
subplot(2,1,1);
step(sys1);
xlabel('Time [s]'); ylabel('i(t) --- Vc [V]'); grid on;

subplot(2,1,2);
impulse(sys1);
xlabel('Time [s]'); ylabel('i(t) --- Vc [V]'); grid on;
sgtitle("Grafica EE Resuelto en clase");

%% Pasar de EE a ft y viceversa
% De Espacio de Estados a ft 
[num1, den1] = ss2tf(A1, B1, C1(1,:), D1); % v_c(s)/U(s)
[num2, den2] = ss2tf(A1, B1, C1(2,:), D1); % i(s)/U(s)
G1 =  tf(num1, den1); G2 =  tf(num2, den2);
% ft a Espacio de Estados
[Ap, Bp, Cp, Dp] = tf2ss(num1, den1);

%% Espacio de estados (integracion RK)
function dx = modelRLC(t, x, A, B, u)
    dx = A * x + B * u; % Ecuación de Estado
end

ts = 0.015;      % Tiempo de simulación
tspan = [0 ts];  % Intervalo de tiempo
u = 1;           % Voltaje de entrada
x0 = [0; 0];     % Condiciones iniciales
[t, X] = ode45(@(t,x) modelRLC(t, x, A1, B1, u), tspan, x0);
y = C1 * X.' + D1 * u;

% Gráfica del resultado
figure();
plot(t, y);
xlabel('Tiempo [s]');
ylabel('Vc [V]');
title('Respuesta del sistema RLC usando ode45');
grid on;

%% 4. Respuesta a una señal arbitraria (PRBS)
ts = 0.1;      % Periodo de muestreo
t_total = 40;  % Tiempo total de simulación

t1 = 0:ts:10-ts; y1 = sin(2*pi*0.25*t1);            % 0-10s → Sinusoidal 
t2 = 10:ts:15-ts; y2 = 3 * ones(size(t2));          % 10-15s → Escalón (valor 3)
t3 = 15:ts:20-ts; y3 = linspace(3, 5, length(t3));  % 15-20s → Rampa ascendente (3 a 5)
t4 = 20:ts:25-ts; y4 = 5 * ones(size(t4));          % 20-25s → Escalón (valor 5)
t5 = 25:ts:30-ts; y5 = linspace(5, -3, length(t5)); % 25-30s → Rampa descendente (5 a -3)
t6 = 30:ts:t_total; y6 = -3 * ones(size(t6));       % 30-40s → Escalón de bajada (-3)

% Combinar todas las secciones
valores = [y1, y2, y3, y4, y5, y6]';

ts = 0.05;   % Tiempo de simulación
x0 = [0; 0]; % Estado inicial
tspan = linspace(0, ts, length(valores));

% Inicialización
N = length(valores);
X = zeros(N, 2);
X(1, :) = x0';
t = zeros(N, 1);
t(1) = tspan(1);

for k = 2:N
    u = valores(k);
    [tk, Xk] = ode45(@(t, x) modelRLC(t, x, A1, B1, u), [tspan(k-1), tspan(k)], X(k-1, :)');
    t(k) = tk(end, :);
    X(k, :) = Xk(end, :);
end

% Cálculo de la salida
y = C1 * X' + D1 * valores';

%% Graficas
figure;
subplot(2,1,1);
plot(tspan, valores, 'b');
title('Señal de entrada');
xlabel('Tiempo [s]');
ylabel('Amplitud'); grid on;

subplot(2,1,2);
plot(t, y, 'r');
title('Salida del sistema');
xlabel('Tiempo [s]');
ylabel('Voltaje V_c [V]'); grid on;