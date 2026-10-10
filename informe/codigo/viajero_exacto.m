function [t_opt, ruta_opt] = viajero_exacto()
% VIAJERO_EXACTO Optimo exacto del problema del viajero (ciclo cerrado) por
% programacion dinamica de Held-Karp. Solo se usa como referencia para
% validar el algoritmo genetico: su costo es O(n^2 * 2^n), viable para
% n = 13 pero no para problemas grandes.
T = datos_viajero();
n = size(T,1);
m = n - 1;                          % ciudades 2..n (la 1 es el inicio)
C = inf(2^m, m);                    % C(S, j): costo minimo 1 -> S -> j
P = zeros(2^m, m);                  % predecesor para reconstruir la ruta
for j = 1:m
    C(bitshift(1, j-1) + 1, j) = T(1, j+1);
end
for S = 1:2^m-1
    for j = 1:m
        if ~bitget(S, j) || isinf(C(S+1, j)), continue; end
        for k = 1:m
            if bitget(S, k), continue; end
            S2 = bitset(S, k);
            c = C(S+1, j) + T(j+1, k+1);
            if c < C(S2+1, k)
                C(S2+1, k) = c;
                P(S2+1, k) = j;
            end
        end
    end
end
lleno = 2^m - 1;
[t_opt, j] = min(C(lleno+1, :)' + T(2:n, 1));
ruta = zeros(1, m); S = lleno;
for pos = m:-1:1
    ruta(pos) = j + 1;
    jp = P(S+1, j);
    S = bitset(S, j, 0);
    j = jp;
end
ruta_opt = [1, ruta];
end
