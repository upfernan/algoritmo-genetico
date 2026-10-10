function p = datos_inventario()
% DATOS_INVENTARIO Parametros de la Tabla II (miles de COP).
p.D     = [12000 80000 150000 50000 100000];  % ventas anuales
p.m     = [20 220 900 120 180];               % valor promedio por pedido
p.mu    = [300 4000 7000 2000 3500];          % media de la demanda en el tiempo de reposicion
p.sigma = [100 1200 2500 700 1100];           % desviacion estandar de esa demanda
p.Smax  = [200 1200 2500 800 1500];           % c1: tope del stock de seguridad
p.Kmax  = [500 2000 5000 1500 3000];          % c2: tope de la demanda definida por la empresa
p.I     = 8000;                               % inversion promedio en inventario (Ec. 9)
% Limites asumidos para Q (la tabla dice (0, inf)):
%  - Qmin = 1 (mil COP) para evitar la division por cero en D/Q.
%  - Qmax = 2*I: aun si todo el presupuesto se destinara a un solo item y
%    su stock de seguridad fuera cero, Q/2 no podria superar I.
p.Qmin  = 1;
p.Qmax  = 2*p.I;
p.n     = numel(p.D);
end
