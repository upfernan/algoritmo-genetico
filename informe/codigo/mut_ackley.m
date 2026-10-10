function hijos = mut_ackley(hijos, Pm, sigma_m, lim)
% MUT_ACKLEY Mutacion gaussiana (Ecuaciones 13 y 14). Cada individuo muta
% con probabilidad Pm: se escoge un gen x_i al azar y se hace
% x_i' = x_i + r, con r ~ N(0, sigma_m^2). El resultado se recorta a lim.
if nargin < 4, lim = [-10 10]; end
[n, d] = size(hijos);
for i = 1:n
    if rand < Pm
        j = randi(d);
        hijos(i,j) = min(max(hijos(i,j) + sigma_m*randn, lim(1)), lim(2));
    end
end
end
