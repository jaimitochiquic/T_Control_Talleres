import numpy as np
import matplotlib.pyplot as plt
from scipy import signal
import control as ctrl
from numpy.polynomial import polynomial as P

# Configuración para gráficas
plt.rcParams['figure.figsize'] = (10, 8)

# ==============================================================================
# DEFINICIÓN DEL SISTEMA
# ==============================================================================
num = [1, 3]
den = [1, 5, 20, 16, 0]
H = 1

# Crear función de transferencia en lazo abierto
Gol = ctrl.TransferFunction(num, den)
print("Función de transferencia en lazo abierto:")
print(Gol)

# Sistema en lazo cerrado
Gcl = ctrl.feedback(Gol, H)
print("\nFunción de transferencia en lazo cerrado:")
print(Gcl)

# ==============================================================================
# CALCULAR CEROS Y POLOS
# ==============================================================================
zs = np.roots(num)
ps = np.roots(den)

print("\nCeros del sistema:")
print(zs)
print("\nPolos del sistema:")
print(ps)

# ==============================================================================
# FIGURA 1: RESPUESTA AL ESCALÓN
# ==============================================================================
plt.figure(1)
t, y = ctrl.step_response(Gcl)
plt.plot(t, y)
plt.grid(True)
plt.title("Respuesta al sistema")
plt.xlabel("Tiempo (s)")
plt.ylabel("Amplitud")
plt.tight_layout()

# ==============================================================================
# FIGURA 2: DIAGRAMA DE POLOS Y CEROS AUTOMÁTICO
# ==============================================================================
plt.figure(2)
ctrl.pzmap(Gcl, plot=True)
plt.title("Diagrama de Polos y Ceros (pzmap)")
plt.grid(True)
plt.axis('equal')
plt.tight_layout()

# ==============================================================================
# FIGURA 3: GRÁFICA MANUAL DE POLOS Y CEROS
# ==============================================================================
plt.figure(3)
plt.plot(np.real(zs), np.imag(zs), 'o', color=[0.49, 0.18, 0.56], 
         linewidth=2, markersize=10, label='Ceros')
plt.plot(np.real(ps), np.imag(ps), 'rx', linewidth=2, 
         markersize=10, label='Polos')
plt.grid(True)
plt.axis('square')
plt.xlim([-6, 6])
plt.ylim([-6, 6])
plt.title('LGR (polos y ceros - Manual)')
plt.xlabel('Eje Real')
plt.ylabel('Eje Imaginario')

# ==============================================================================
# CÁLCULO DE ASÍNTOTAS Y CENTROIDE
# ==============================================================================
np_count = len(ps)
nz_count = len(zs)
n_asintotas = np_count - nz_count

print(f"\nNúmero de polos: {np_count}")
print(f"Número de ceros: {nz_count}")
print(f"Número de asíntotas: {n_asintotas}")

# Ángulos de las asíntotas
asintotas_angulos = (180/np.pi) * ((2*np.arange(n_asintotas) + 1)*np.pi) / n_asintotas
print(f"\nÁngulos de asíntotas: {asintotas_angulos}")

# Centroide
sigma0 = (np.sum(np.real(ps)) - np.sum(np.real(zs))) / n_asintotas
print(f"Centroide σ₀: {sigma0}")

# Graficar centroide
plt.plot(sigma0, 0, 'go', linewidth=2, markersize=10, label='Centroide')
plt.text(sigma0+0.2, 0.2, r'$\sigma_0$', fontsize=12)

# ==============================================================================
# GRAFICAR ASÍNTOTAS
# ==============================================================================
x = np.arange(sigma0, 6, 0.1)
y1 = np.sqrt(3) * (x - sigma0)
y2 = -y1
xa = np.arange(-6, sigma0, 0.1)
ya = np.zeros_like(xa)

plt.plot(x, y1, 'k-.', linewidth=1.5, label='Asíntotas')
plt.plot(x, y2, 'k-.', linewidth=1.5)
plt.plot(xa, ya, 'k-.', linewidth=1.5)

# Cruce con eje imaginario
plt.plot(0, np.sqrt(3)*sigma0, 'd', linewidth=2, markersize=8, 
         color=[0.3, 0.15, 0.05], label='Cruce eje jω')
plt.plot(0, -np.sqrt(3)*sigma0, 'd', linewidth=2, markersize=8, 
         color=[0.3, 0.15, 0.05])

# ==============================================================================
# PUNTOS DE LLEGADA/SALIDA DEL LGR
# ==============================================================================
# Calcular dK/ds = 0
# K = -den(s)/num(s)
# Para este sistema: K = -(s^4 + 5s^3 + 20s^2 + 16s)/(s+3)

# Derivada: 3s^4 + 22s^3 + 65s^2 + 120s + 48 = 0
coef_derivada = [3, 22, 65, 120, 48]
p_llegada = np.roots(coef_derivada)

print("\nPuntos candidatos de llegada/salida:")
for i, s0 in enumerate(p_llegada):
    # Evaluar K en el punto
    if abs(s0) > 1e-10:
        K_eval = -(s0**4 + 5*s0**3 + 20*s0**2 + 16*s0) / (s0 + 3)
    else:
        K_eval = 0
    
    print(f"s{i+1} = {s0:.4f}, K = {K_eval:.4f}")
    
    # Condición: K real y positivo, y s real
    if abs(np.imag(K_eval)) < 1e-3 and np.real(K_eval) > 0 and abs(np.imag(s0)) < 1e-3:
        plt.plot(np.real(s0), np.imag(s0), 'ks', linewidth=2, markersize=10)
        print(f"  -> Pertenece al LGR")

# ==============================================================================
# GANANCIA CRÍTICA Y CRUCE CON EJE IMAGINARIO
# ==============================================================================
# Usar margin para obtener ganancia de margen
gm, pm, wcg, wcp = ctrl.margin(Gol)
K_crit = gm
print(f"\nGanancia crítica K_crit: {K_crit:.4f}")

# Calcular raíces en K crítico
den_cl_crit = np.array(den) + K_crit * np.array([0, 0, 0] + num)
s_all = np.roots(den_cl_crit)

# Filtrar polos en eje imaginario (parte real ≈ 0)
s_crit = s_all[np.abs(np.real(s_all)) < 1e-3]
print(f"Raíces críticas: {s_crit}")

plt.plot(np.real(s_crit), np.imag(s_crit), 'dm', linewidth=2, markersize=12)
if len(s_crit) > 0:
    plt.text(np.real(s_crit[0])+0.2, np.imag(s_crit[0])+0.2, 
             r'$K_{crit}$', fontsize=12)

# ==============================================================================
# ÁNGULOS DE SALIDA DESDE POLOS COMPLEJOS
# ==============================================================================
polos_c = ps[np.imag(ps) != 0]
print(f"\nPolos complejos: {polos_c}")

for s0 in polos_c:
    # Ángulos desde s0 hacia otros polos
    otros_polos = ps[ps != s0]
    ang_p = np.angle(s0 - otros_polos)
    
    # Ángulos desde s0 hacia ceros
    ang_z = np.angle(s0 - zs)
    
    print(f"\nPolo s0 = {s0}")
    print(f"Ángulos a polos (grados): {np.rad2deg(ang_p)}")
    print(f"Ángulos a ceros (grados): {np.rad2deg(ang_z)}")
    
    # Calcular ángulo de salida
    theta = 180 - np.sum(np.rad2deg(ang_p)) + np.sum(np.rad2deg(ang_z))
    theta = ((theta + 180) % 360) - 180  # Normalizar a [-180, 180]
    
    print(f"Ángulo de salida: {theta:.2f}°")
    
    # Graficar vector de dirección
    dx = 2 * np.cos(np.deg2rad(theta))
    dy = 2 * np.sin(np.deg2rad(theta))
    plt.quiver(np.real(s0), np.imag(s0), dx, dy, 
               angles='xy', scale_units='xy', scale=1,
               color=[0.2, 0.2, 0.2], width=0.006)
    break  # Solo el primer polo complejo

# ==============================================================================
# CONSTRUCCIÓN DEL LGR COMPLETO
# ==============================================================================
K_range = np.linspace(0, 500, 1000)

for K_val in K_range:
    # Polinomio característico: den + K*num
    poli_car = np.array(den) + K_val * np.array([0, 0, 0] + num)
    lgr_roots = np.roots(poli_car)
    
    plt.plot(np.real(lgr_roots), np.imag(lgr_roots), '.', 
             color=[0, 0.2, 0.8], markersize=2)

plt.legend(loc='best')
plt.tight_layout()

# ==============================================================================
# FIGURA 4: VALIDACIÓN CON RLOCUS
# ==============================================================================
plt.figure(4)
rlist, klist = ctrl.root_locus(Gol, plot=True)
plt.xlim([-6, 6])
plt.ylim([-6.1, 6.1])
plt.title("LGR usando control.root_locus()")
plt.grid(True)
plt.tight_layout()

# ==============================================================================
# MOSTRAR TODAS LAS FIGURAS
# ==============================================================================
plt.show()

print("\n" + "="*60)
print("Análisis del LGR completado exitosamente")
print("="*60)