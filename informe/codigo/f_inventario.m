function Z = f_inventario(X, metodo)
% F_INVENTARIO Numero esperado de pedidos no atendidos por falta de stock
% (Ecuacion 8 de la guia). X = [Q(1:5), S(1:5), K(1:5)].
% metodo = 'integral' (por defecto): usa el comando integral de MATLAB.
% metodo = 'cerrada': usa la funcion de perdida de la normal (solo para
%                     verificar el resultado numerico).
if nargin < 2, metodo = 'integral'; end
persistent p
if isempty(p)
    p = datos_inventario();
end
n = p.n;
Q = X(1:n); S = X(n+1:2*n); K = X(2*n+1:3*n);
R = S + K;                         % punto de reorden
switch metodo
    case 'integral'
        % Cambio de variable x = R + t, t en [0, inf): el integrando queda
        % t * f(R + t) y se integra para los 5 items a la vez (ArrayValued).
        g = @(t) t .* exp(-0.5*((R + t - p.mu)./p.sigma).^2) ./ (sqrt(2*pi)*p.sigma);
        E = integral(g, 0, Inf, 'ArrayValued', true);
    case 'cerrada'
        z = (R - p.mu)./p.sigma;
        phi = exp(-z.^2/2)/sqrt(2*pi);
        E = p.sigma .* (phi - z.*(0.5*erfc(z/sqrt(2))));
end
Z = sum(p.D ./ Q .* E ./ p.m);
end
