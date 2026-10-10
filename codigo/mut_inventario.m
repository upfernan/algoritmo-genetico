function hijos = mut_inventario(hijos, Pm, sigma_rel)
% MUT_INVENTARIO Mutacion gaussiana para el problema de inventarios.
% Cada individuo muta con probabilidad Pm: se escoge al azar una de las 14
% variables independientes (Q1..Q4, S1..S5, K1..K5) y se le suma
% r ~ N(0, (sigma_rel*rango)^2), donde rango es el ancho del intervalo
% permitido para esa variable (las variables tienen escalas distintas).
% El valor se recorta a sus limites y luego se recalcula Q5 con la
% Ecuacion 9. Si Q5 queda fuera de [Qmin, Qmax] se descarta la mutacion y
% se intenta de nuevo (maximo 10 intentos; si no, el individuo no cambia).
p = datos_inventario();
k = p.n;
lo = [p.Qmin*ones(1,k), zeros(1,k), zeros(1,k)];
hi = [p.Qmax*ones(1,k), p.Smax,     p.Kmax];
independientes = [1:k-1, k+1:3*k];              % todas menos Q5
for i = 1:size(hijos, 1)
    if rand < Pm
        for intento = 1:10
            x = hijos(i,:);
            j = independientes(randi(numel(independientes)));
            x(j) = min(max(x(j) + sigma_rel*(hi(j) - lo(j))*randn, lo(j)), hi(j));
            x(k) = 2*(p.I - sum(x(k+1:2*k)) - sum(x(1:k-1))/2);   % Q5 (Ec. 9)
            if x(k) >= p.Qmin && x(k) <= p.Qmax
                hijos(i,:) = x;
                break
            end
        end
    end
end
end
