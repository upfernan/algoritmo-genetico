function y = f_ackley(X, a, b, c)
% F_ACKLEY Funcion Ackley modificada (Ecuacion 6 de la guia).
% X es un vector de d dimensiones. Se usa "+ a + 3" en lugar de "+ a + e",
% por lo que el minimo global es 3 - e (en X = 0).
if nargin < 2, a = 20;     end
if nargin < 3, b = 0.2;    end
if nargin < 4, c = 2*pi;   end
d = numel(X);
y = -a*exp(-b*sqrt(sum(X.^2)/d)) - exp(sum(cos(c*X))/d) + a + 3;
end
