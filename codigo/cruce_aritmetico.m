function hijos = cruce_aritmetico(padres)
% CRUCE_ARITMETICO Cruce aritmetico completo [Herrera et al., 1998].
% Para cada pareja (p1, p2) se sortea lambda ~ U(0,1) y:
%   h1 = lambda*p1 + (1 - lambda)*p2
%   h2 = (1 - lambda)*p1 + lambda*p2
% Como los hijos son combinaciones convexas de los padres, conservan
% automaticamente la restriccion lineal de igualdad sum(Q/2 + S) = I y
% los limites de caja de todas las variables (Tabla II).
[np, d] = size(padres);
hijos = zeros(np, d);
for k = 1:2:np-1
    p1 = padres(k,:); p2 = padres(k+1,:);
    lambda = rand;
    hijos(k,:)   = lambda*p1 + (1 - lambda)*p2;
    hijos(k+1,:) = (1 - lambda)*p1 + lambda*p2;
end
end
