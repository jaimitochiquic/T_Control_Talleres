# ============================================================
#  ESPACIO DE ESTADOS
#  Autor: Jaime Patricio Chiqui Chiqui
#  Universidad de Cuenca - Ingeniería en Telecomunicaciones
# ============================================================

import numpy as np
import matplotlib.pyplot as plt
from control import ss, step_response, impulse_response, ss2tf, tf2ss, tf
from scipy.integrate import solve_ivp

# Limpiar entorno
plt.close('all')

# Parámetros del circuito
R = 100      # Resistencia (ohmios)
L = 0.1      # Inductancia (henrios)
Cap = 1e-6   # Capacitancia (faradios)

# %% Matriz de estados de la Guía
A = np.array([[0, 1],
              [-1/(L*Cap), -R/L]])  # Matriz de Estado
B = np.array([[0],
              [1/L]])               # Matriz de Entrada
C = np.array([[1/Cap, 0]])          # Matriz de Salida
D = np.array([[0]])                 # Matriz de Transferencia directa

sys = ss(A, B, C, D)

# Respuestas al escalón e impulso
t1, y1 = step_response(sys)
t2, y2 = impulse_response(sys)

plt.figure()
plt.subplot(2, 1, 1)
plt.plot(t1, y1.T)
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc [V]')
plt.grid(True)
plt.title("Respuesta al escalón - Guía")

plt.subplot(2, 1, 2)
plt.plot(t2, y2.T)
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc [V]')
plt.grid(True)
plt.title("Respuesta al impulso - Guía")
plt.suptitle("Gráficas de la Guía")
plt.show()

# %% Resuelto en clase
# x1 = i(t); x2 = Vc(t)
A1 = np.array([[-R/L, -1/L],
               [1/Cap, 0]])          # Matriz de Estado
B1 = np.array([[1/L],
               [0]])                 # Matriz de Entrada
C1_vc = np.array([[0, 1]])           # Salida: voltaje en el capacitor
C1_i = np.array([[1, 0]])            # Salida: corriente
D1 = np.array([[0]])                 # Matriz de Transferencia directa

# Sistemas individuales
sys_vc = ss(A1, B1, C1_vc, D1)
sys_i = ss(A1, B1, C1_i, D1)

# Respuestas al escalón
t3, y3_vc = step_response(sys_vc)
_, y3_i = step_response(sys_i)

# Respuestas al impulso
t4, y4_vc = impulse_response(sys_vc)
_, y4_i = impulse_response(sys_i)

plt.figure()
plt.subplot(2, 1, 1)
plt.plot(t3, y3_vc.T, label='v_c')
plt.plot(t3, y3_i.T, label='i')
plt.xlabel('Tiempo [s]')
plt.ylabel('i(t) --- Vc [V]')
plt.grid(True)
plt.legend()

plt.subplot(2, 1, 2)
plt.plot(t4, y4_vc.T, label='v_c')
plt.plot(t4, y4_i.T, label='i')
plt.xlabel('Tiempo [s]')
plt.ylabel('i(t) --- Vc [V]')
plt.grid(True)
plt.legend()
plt.suptitle("Gráfica EE Resuelto en clase")
plt.show()


# %% Espacio de estados (integración numérica Runge-Kutta)
def modelRLC(t, x, A, B, u):
    """Ecuación de estado dx/dt = A*x + B*u"""
    return (A @ x + B.flatten() * u).flatten()

ts = 0.015      # Tiempo de simulación
tspan = [0, ts]  # Intervalo de tiempo
u = 1            # Voltaje de entrada
x0 = [0, 0]      # Condiciones iniciales

sol = solve_ivp(lambda t, x: modelRLC(t, x, A1, B1, u),
                tspan, x0, method='RK45', max_step=1e-4)
y = (C1_vc @ sol.y + D1 * u)

plt.figure()
plt.plot(sol.t, y[0, :], label='v_c')
plt.xlabel('Tiempo [s]')
plt.ylabel('Vc [V]')
plt.title('Respuesta del sistema RLC usando solve_ivp (ode45)')
plt.grid(True)
plt.legend()
plt.show()

# %% 4. Respuesta a una señal arbitraria (PRBS)
ts = 0.1
t_total = 40

# Definir segmentos de la señal
t1 = np.arange(0, 10, ts);  y1 = np.sin(2*np.pi*0.25*t1)
t2 = np.arange(10, 15, ts); y2 = 3 * np.ones_like(t2)
t3 = np.arange(15, 20, ts); y3 = np.linspace(3, 5, len(t3))
t4 = np.arange(20, 25, ts); y4 = 5 * np.ones_like(t4)
t5 = np.arange(25, 30, ts); y5 = np.linspace(5, -3, len(t5))
t6 = np.arange(30, t_total + ts, ts); y6 = -3 * np.ones_like(t6)

# Combinar todas las secciones
valores = np.concatenate((y1, y2, y3, y4, y5, y6))

ts = 0.05     # Tiempo de simulación
x0 = np.array([0, 0])  # Estado inicial
tspan = np.linspace(0, ts, len(valores))

# Inicialización
N = len(valores)
X = np.zeros((N, 2))
X[0, :] = x0
t = np.zeros(N)
t[0] = tspan[0]

# Integración del sistema (Runge-Kutta de orden 4/5)
for k in range(1, N):
    u = valores[k]
    sol = solve_ivp(lambda t, x: modelRLC(t, x, A1, B1, u),
                    [tspan[k-1], tspan[k]], X[k-1, :],
                    method='RK45', max_step=ts)
    t[k] = sol.t[-1]
    X[k, :] = sol.y[:, -1]

# Cálculo de la salida
y = (C1_vc @ X.T + D1 * valores).T

# Gráficas
plt.figure()
plt.subplot(2, 1, 1)
plt.plot(tspan, valores, 'b')
plt.title('Señal de entrada')
plt.xlabel('Tiempo [s]')
plt.ylabel('Amplitud')
plt.grid(True)

plt.subplot(2, 1, 2)
plt.plot(t, y[:, 0], 'r')
plt.title('Salida del sistema')
plt.xlabel('Tiempo [s]')
plt.ylabel('Voltaje V_c [V]')
plt.grid(True)
plt.tight_layout()
plt.show()