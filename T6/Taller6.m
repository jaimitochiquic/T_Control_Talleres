clc, clear all, close all;

num = [1];
den = [2 1]; 
G_s = tf(num, den);
[y, t] = step(G_s, 0:0.01:12); % Forzamos t
[~, idx] = min(abs(t - 8));    % obtener y(8)
roots(den)

figure(); hold on;
plot(t, y);
plot(8, y(idx), '*', 'Color', [1 0 0]);
legend('Respuesta al escalon', 'Estabilizacion: $t = 4\tau$', 'Interpreter', 'latex');
title('Sistema Estable G_1(s)'); grid on;

den = [2 -1];
G_s2 = tf(num, den);
[y, t] = step(G_s2, 0:0.01:120); % Forzamos t
[~, idx] = min(abs(t - 8));    % obtener y(8)
roots(den)

figure(); hold on;
plot(t, y);
plot(8, y(idx), '*', 'Color', [1 0 0]);
legend('Respuesta al escalon', 'Estabilizacion: $t = 4\tau$', 'Interpreter', 'latex');
title('Sistema Inestable G_2(s)'); grid on;

%% Parte final
clc, clear all, close all;
t = 0:0.01:45;

num1 = [3]; den1 = [1 0];
G1 = tf(num1, den1)
num2 = [1]; den2 = [1 0 1];
G2 = tf(num2, den2)
num3 = [3]; den3 = [1];
H1 = tf(num3, den3)

% Bloques en Serie: Combinar G1 y G2
Gol = series(G1, G2)  % G1 * G2

% lazo cerrado (retroalimentado)
Gcl = feedback(Gol, H1)
[y, t] = step(Gcl, t);

figure(); subplot(1,2,1);
plot(t, y); ylim([-10, 100]);
title("Respuesta al Escalon (Gcl)")
grid("on"); subplot(1,2,2);
pzmap(Gcl)

% tabla Routh
[num_cl, den_cl] = tfdata(Gcl, 'v')
roots(den_cl) % polos Gcl