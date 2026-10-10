function ganadores = sel_ruleta(fitness)
% SEL_RULETA Seleccion por ruleta para minimizacion (Ecuacion 12).
% La probabilidad de escoger al individuo i es inversamente proporcional a
% su fitness: P_i = (1/f_i) / sum(1/f_j). Se gira la ruleta n/2 veces
% (con reemplazo, un individuo puede salir escogido mas de una vez).
n = numel(fitness);
inv = 1 ./ max(fitness(:), eps);     % se evita dividir por cero
P = inv / sum(inv);
acumulada = cumsum(P);
acumulada(end) = 1;
giros = rand(floor(n/2), 1);
ganadores = zeros(floor(n/2), 1);
for i = 1:numel(giros)
    ganadores(i) = find(giros(i) <= acumulada, 1, 'first');
end
end
