function r = correr_escenario(prob, op, n_pruebas, optimo)
% CORRER_ESCENARIO Ejecuta el algoritmo genetico n_pruebas veces con la
% misma configuracion (semillas 1..n_pruebas, reproducible) y resume:
%   tiempo promedio, mejor valor, individuo del mejor valor, promedio,
%   desviacion estandar y RMSE respecto al optimo (si se conoce).
if nargin < 4, optimo = NaN; end
Y = zeros(n_pruebas, 1);
t = zeros(n_pruebas, 1);
X = cell(n_pruebas, 1);
conv = zeros(op.iter + 1, n_pruebas);
for k = 1:n_pruebas
    rng(k);
    res = algoritmo_genetico(prob, op);
    Y(k) = res.mejor_f; t(k) = res.tiempo; X{k} = res.mejor_x;
    conv(:, k) = res.convergencia;
end
[r.mejor_f, ib] = min(Y);
r.mejor_x  = X{ib};
r.promedio = mean(Y);
r.desv     = std(Y);
r.rmse     = sqrt(mean((Y - optimo).^2));
r.tiempo   = mean(t);
r.Y = Y; r.X = X; r.conv = conv; r.op = op;
end
