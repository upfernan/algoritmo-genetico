function hijos = mut_viajero(hijos, Pm)
% MUT_VIAJERO Mutacion por intercambio (swap). Cada individuo muta con
% probabilidad Pm: se escogen 2 posiciones distintas al azar y se
% intercambian sus valores, de modo que sigue siendo una permutacion.
[n, m] = size(hijos);
for i = 1:n
    if rand < Pm
        pos = randperm(m, 2);
        hijos(i, pos) = hijos(i, fliplr(pos));
    end
end
end
