function pob = pob_viajero(n, m)
% POB_VIAJERO Genera n rutas aleatorias. Cada fila es una permutacion de
% los numeros 1..m (m = 13 por defecto), sin elementos repetidos.
if nargin < 2, m = 13; end
pob = zeros(n, m);
for i = 1:n
    pob(i,:) = randperm(m);
end
end
