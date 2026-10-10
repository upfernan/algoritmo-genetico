function hijos = cruce_ox(padres)
% CRUCE_OX Cruce por orden (Order Crossover, OX) para permutaciones
% [Larranaga et al., 1999]. Se aparean las filas 1-2, 3-4, ...; cada pareja
% genera 2 hijos. Para cada hijo:
%   1. Se escogen 2 puntos de corte al azar.
%   2. El hijo copia el segmento entre los cortes de uno de los padres.
%   3. Las posiciones restantes se llenan, empezando despues del segundo
%      corte, con las ciudades del otro padre en el orden en que aparecen
%      en el (desde su segundo corte), omitiendo las ya copiadas.
% Asi los hijos siempre son permutaciones validas.
[np, m] = size(padres);
hijos = zeros(np, m);
for k = 1:2:np-1
    p1 = padres(k,:); p2 = padres(k+1,:);
    cortes = sort(randperm(m, 2));
    hijos(k,:)   = ox_un_hijo(p1, p2, cortes(1), cortes(2));
    hijos(k+1,:) = ox_un_hijo(p2, p1, cortes(1), cortes(2));
end
end

function h = ox_un_hijo(pa, pb, c1, c2)
m = numel(pa);
h = zeros(1, m);
h(c1:c2) = pa(c1:c2);
orden_pb = pb([c2+1:m, 1:c2]);                 % recorrido de pb desde c2+1
restantes = orden_pb(~ismember(orden_pb, pa(c1:c2)));
posiciones = [c2+1:m, 1:c1-1];                 % huecos del hijo desde c2+1
h(posiciones) = restantes;
end
