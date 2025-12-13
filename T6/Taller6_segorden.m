clc; clear; close all;

%% Parámetros Generales
wn = 1;            % Frecuencia natural no amortiguada (rad/s)
t = 0:0.01:16;     % Tiempo de 0 a 16 s

%% Figura 1: No Amortiguado y Sub-amortiguado
figure; hold on;
% 1. Sistema No Amortiguado (zeta = 0)
graficar_sistema(0, wn, t, 1, 'No Amortiguado');
% 2. Sistema Sub-amortiguado (zeta = 0.2)
graficar_sistema(0.2, wn, t, 3, 'subamortiguado');

%% Figura 2: Críticamente Amortiguado y Sobre-amortiguado
figure; hold on;
% 3. Sistema Criticamente Amortiguado (zeta = 1)
graficar_sistema(1, wn, t, 1, 'criticamente amortiguado');
% 4. Sistema Sobre-amortiguado (zeta = 2)
graficar_sistema(2, wn, t, 3, 'sobre amortiguado');

%% --- FUNCIÓN Graficas ---
function graficar_sistema(zeta_val, wn, t, plot_index_start, titulo_tipo)
    % Definición del sistema seg. orden
    num_sys = wn^2;
    den_sys = [1, 2*zeta_val*wn, wn^2];
    G_sys = tf(num_sys, den_sys);
    [Y_sys, T_sys] = step(G_sys, t);
    
    subplot(2, 2, plot_index_start);
    plot(T_sys, Y_sys);
    title(['Respuesta al escalon (' titulo_tipo ')']);
    grid on; 
    
    % Gráfica 2: Mapa de Polos y Ceros
    subplot(2, 2, plot_index_start + 1);
    pzmap(G_sys);
    title(['Diagrama de Polos y Ceros (' titulo_tipo ')']);
end



%% Parte 2
%% clc; clear; close all;
t_inestable = 0:0.01:30;

%% 1. Sistema Inestable Oscilatorio (G1)
% G1 = 1 / (s^2 - 0.5s + 4)
num_G1 = [1];
den_G1 = [1 -0.5 4]; 
G1 = tf(num_G1, den_G1);
roots(den_G1)
analizar_sistema_inestable(G1, t_inestable, ...
    'G1: Inestable Oscilatorio (Polos Complejos)');

%% 2. Sistema Inestable No Oscilatorio (G2)
% G2 = 1 / (25s^2 - 12.5s + 1)
num_G2 = [1];
den_G2 = [25 -12.5 1];
G2 = tf(num_G2, den_G2);
roots(den_G2)
analizar_sistema_inestable(G2, t_inestable, ...
    'G2: Inestable No Oscilatorio (Polos Reales)');

% Graficas
function analizar_sistema_inestable(G_sys, t, titulo_general)
    [Y, T] = step(G_sys, t);
    
    figure(); subplot(1, 2, 1);
    plot(T, Y); % Respuesta al Escalón
    title(['Respuesta al Escalón: ' titulo_general]);
    xlabel('Tiempo (s)'); ylabel('Amplitud');
    grid on;
   
    subplot(1, 2, 2);
    pzmap(G_sys); % Mapa de Polos y Ceros
    title(['Mapa de Polos y Ceros: ' titulo_general]);
end