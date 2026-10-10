function pob = pob_ackley(n, d, lim)
% POB_ACKLEY Genera una matriz n x d con valores uniformes en el intervalo
% lim = [minimo, maximo]. Cada fila es un individuo.
if nargin < 3, lim = [-10 10]; end
pob = lim(1) + (lim(2) - lim(1))*rand(n, d);
end
