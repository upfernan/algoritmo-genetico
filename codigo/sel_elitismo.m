function ganadores = sel_elitismo(fitness)
% SEL_ELITISMO Seleccion por elitismo (minimizacion).
% Ordena los individuos de menor a mayor fitness y retorna los indices de
% la mitad con mejor aptitud.
n = numel(fitness);
[~, orden] = sort(fitness(:), 'ascend');
ganadores = orden(1:floor(n/2));
end
