clc, clear all, close all;
N = 100;

%% Parte inicial RLC
% Parametros Actividad inicial
R = 10;     %[Ohm]
L = 1e-3;   %[H]
C = 100e-6; %[F]

% Funcion de transferencia RLC
num = [1/(L*C)];
den = [1 R/L 1/(L*C)];
G = tf(num, den);

%% ====== RETO (Pasa altas - Salida en Inductor) ==============
% Parametros Actividad Reto (Pasa altas)
R = 100;        % [Ohms]  
L = 112.54e-3;  % [H]
C = 22.5e-6;    % [F]

% Funcion de transferencia RLC (inductor)
num = [1 0 0]; 
den = [1 R/L 1/(L*C)];
G = tf(num, den);

%% ====== RETO (Pasa Banda - Salida en Resistencia) ==========
% Parametros Actividad Reto (Pasa Banda)
R = 100;           % [Ohms]
L = 159.15e-3;     % [H] 
C = 15.915e-6;     % [F]

% Funcion de transferencia RLC (Salida en Resistencia)
% G(s) = ( (R/L)*s ) / ( s^2 + (R/L)*s + 1/(LC) )
num = [R/L 0]; 
den = [1 R/L 1/(L*C)];
G = tf(num, den)

%% Graficamos el D. Bode manualmente
w_manual = logspace(1,7,N); % Vector de frecuencias en rad/s
s = 1j * w_manual;          % s = jw

%% Graficamos el D. Bode comandos Matlab
w = logspace(1,7,N);
bode(G,w);
grid on;
title('Diagrama de Bode - Función bode()');

%% Graficamos el D. Bode manualmente
w_manual = logspace(1,7,N); % Vector de frecuencias en rad/s

% Evaluar la función de transferencia en cada frecuencia
% G(jω) se evalúa sustituyendo s por jω
s = 1j * w_manual;  % s = jω

%% G_jw = num ./ (s.^2 + den(2)*s + den(3));      % G(jω) = Num(jω) / Den(jω)
%% G_jw = (s.^2) ./ (s.^2 + (R/L)*s + 1/(L*C));   % G(jω) Actividad reto inductor
G_jw = ((R/L)*s) ./ (s.^2 + (R/L)*s + 1/(L*C));   % G(jω) Actividad reto Resistencia

% Calcular magnitud en decibeles
magnitud_lineal = abs(G_jw);             % Magnitud en valor absoluto
magnitud_dB = 20*log10(magnitud_lineal); % Magnitud en decibeles [dB]

% Calcular fase en grados
fase_rad = angle(G_jw);                 % Fase en radianes
fase_grados = fase_rad * (180/pi);      % Fase en grados [°]

% Convertir frecuencia a Hertz
f_Hz = w_manual / (2*pi);               % Frecuencia en Hertz [Hz]

% Gráfica de Magnitud
figure(2)
subplot(2,1,1)
semilogx(w_manual, magnitud_dB, 'b', 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia (rad/s)');
ylabel('Magnitud (dB)');
title('Diagrama de Bode Manual - Magnitud');

% Gráfica de Fase
subplot(2,1,2)
semilogx(w_manual, fase_grados, 'r', 'LineWidth', 1.5);
grid on;
xlabel('Frecuencia (rad/s)');
ylabel('Fase (grados)');
title('Diagrama de Bode Manual - Fase');

%% Diagrama de Bode MANUAL en HERTZ
figure(3)

% Gráfica de Magnitud en Hz
subplot(2,1,1)
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

%% Respuestas a las preguntas
fprintf('\n=== RESPUESTAS AL EJERCICIO 1.1 ===\n\n');

fprintf('1. ¿Qué unidad debe tener la magnitud?\n');
fprintf('   R: Decibeles [dB]\n');
fprintf('   Fórmula: 20*log10(|G(jω)|)\n\n');

fprintf('2. ¿Qué unidad debe tener la fase?\n');
fprintf('   R: Grados [°]\n');
fprintf('   Conversión: fase_grados = fase_radianes * (180/pi)\n\n');

fprintf('3. ¿Qué debería hacer para obtener la gráfica en Hertz?\n');
fprintf('   R: Convertir de rad/s a Hz\n');
fprintf('   Fórmula: f[Hz] = ω[rad/s] / (2π)\n\n');

fprintf('4. ¿Cómo hizo para evaluar la función de transferencia en una frecuencia determinada?\n');
fprintf('   R: Sustituyendo s = jω en G(s)\n');
fprintf('   Se evalúa: G(jω) = numerador(jω) / denominador(jω)\n\n');

fprintf('5. ¿Cómo calculó la magnitud?\n');
fprintf('   R: Magnitud = |G(jω)| = abs(G(jω))\n');
fprintf('   En dB: Magnitud_dB = 20*log10(|G(jω)|)\n\n');

fprintf('6. ¿Cómo calculó la fase?\n');
fprintf('   R: Fase = angle(G(jω)) [en radianes]\n');
fprintf('   En grados: Fase_grados = angle(G(jω)) * (180/pi)\n\n');