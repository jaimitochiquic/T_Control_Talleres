import numpy as np
import matplotlib.pyplot as plt
import control as ctrl

# --- Parámetros del Circuito RLC (Taller 5) ---
R = 5       # Resistencia (Ohmios)
L = 0.1     # Inductancia (Henrios)
C = 220e-6  # Capacitancia (Faradios)

# Parámetros PID Sintonizados (PID Tuner) ---
Kp = 16.7573
Ki = 1762.8024
Kd = 0.03622
N  = 6402.7121

# --- Función de Transferencia de la Planta (G_p(s)) ---
# Gp(s) = A / (s^2 + (R/L)s + A), donde A = 1/(L*C)
A = 1 / (L * C)
Num_p = [A]
Den_p = [1, R/L, A]
G_RLC = ctrl.TransferFunction(Num_p, Den_p)
print('Función de Transferencia de la Planta G_p(s):')
print(G_RLC)

# --- Función de Transferencia del Controlador (G_c(s)) ---
# Gc(s) = Kp + Ki/s + Kd * (N*s / (s + N))
Num_c = [(Kd*N + Kp), (Kp*N + Ki), (Ki*N)]
Den_c = [1, N, 0]  # s*(s+N) = s^2 + Ns + 0
CPID = ctrl.TransferFunction(Num_c, Den_c)
print('Función de Transferencia del Controlador Filtrado G_c(s):')
print(CPID)

# --- Sistema en Lazo Cerrado (Gcl) ---
# Gcl = Gc(s) * Gp(s) / (1 + Gc(s) * Gp(s))
Gcl = ctrl.feedback(CPID * G_RLC, 1)
print('Función de Transferencia del Sistema en Lazo Cerrado G_CL(s):')
print(Gcl)

# --- Análisis de Estabilidad ---
# Hallar los Polos (raíces del Polinomio Característico)
p = ctrl.poles(Gcl)
print('Ubicación de los Polos (Raíces del Polinomio Característico):')
print(p)

# Verificar estabilidad
Real_Part = np.real(p)
if np.all(Real_Part < 0):
    print('=> El sistema es ESTABLE (Todos los polos están en el semiplano izquierdo).')
else:
    print('=> El sistema es INESTABLE.')

# --- Gráficas de Análisis ---
# Respuesta al escalón
plt.figure()
time, response = ctrl.step_response(Gcl)
plt.plot(time, response)
plt.title('Respuesta al Escalón del Sistema RLC con PID Filtrado')
plt.grid(True)

# Diagrama de Polos y Ceros
plt.figure()
ctrl.pzmap(Gcl)
plt.title('Diagrama de Polos y Ceros del Sistema en Lazo Cerrado')
plt.grid(True)

plt.show()