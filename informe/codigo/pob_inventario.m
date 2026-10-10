function pob = pob_inventario(n)
% POB_INVENTARIO Genera n individuos X = [Q(1:5), S(1:5), K(1:5)].
% Se generan 14 variables (S1..S5, K1..K5, Q1..Q4) dentro de los limites de
% la Tabla II y Q5 se calcula con la restriccion de igualdad (Ecuacion 9):
%       sum(Q/2 + S) = I   =>   Q5 = 2*(I - sum(S) - sum(Q1..Q4)/2)
% Para que Q5 siempre resulte positivo, Q1..Q4 se generan como fracciones
% aleatorias del presupuesto que queda libre despues de fijar S.
p = datos_inventario();
k = p.n;
pob = zeros(n, 3*k);
for i = 1:n
    S = p.Smax .* rand(1, k);
    K = p.Kmax .* rand(1, k);
    libre = p.I - sum(S);                       % presupuesto para sum(Q/2)
    w = -log(rand(1, k)); w = w/sum(w);         % fracciones aleatorias (Dirichlet(1))
    Q = zeros(1, k);
    Q(1:k-1) = p.Qmin + 2*(libre - k*p.Qmin/2)*w(1:k-1);
    Q(k) = 2*(p.I - sum(S) - sum(Q(1:k-1))/2);  % variable dependiente (Ec. 9)
    pob(i,:) = [Q, S, K];
end
end
