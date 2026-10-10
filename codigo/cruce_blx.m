function hijos = cruce_blx(padres, alfa, lim)
% CRUCE_BLX Cruce BLX-alfa para codificacion real [Herrera, Lozano y
% Verdegay, 1998]. Para cada gen, con Cmin = min(p1,p2), Cmax = max(p1,p2) e
% I = Cmax - Cmin, el hijo toma un valor uniforme en
% [Cmin - alfa*I, Cmax + alfa*I]. Luego se recorta al dominio lim.
% Se aparean las filas 1-2, 3-4, ...; cada pareja genera 2 hijos.
if nargin < 2, alfa = 0.5; end
if nargin < 3, lim = [-10 10]; end
[np, d] = size(padres);
hijos = zeros(np, d);
for k = 1:2:np-1
    p1 = padres(k,:); p2 = padres(k+1,:);
    cmin = min(p1, p2); cmax = max(p1, p2); I = cmax - cmin;
    inf_ = cmin - alfa*I; sup_ = cmax + alfa*I;
    hijos(k,:)   = inf_ + (sup_ - inf_).*rand(1, d);
    hijos(k+1,:) = inf_ + (sup_ - inf_).*rand(1, d);
end
hijos = min(max(hijos, lim(1)), lim(2));
end
