% PRUEBAS Verificacion de cada componente antes de los experimentos.
clc; rng(1);
fprintf('--- Funcion objetivo: viajero ---\n');
[T, ~] = datos_viajero();
fprintf('Suma de la tabla = %d (guia: 9534)\n', sum(T(:)));
fprintf('f(1:13) ciclo cerrado = %d (guia: 641 + regreso = 730)\n', f_viajero(1:13));
fprintf('Lista invalida [1 1 3 ... 13] = %d (debe ser >= 10000)\n', f_viajero([1 1 3:13]));

fprintf('--- Funcion objetivo: Ackley ---\n');
for d = [1 2 3 10 100]
    fprintf('d = %3d: f(0) = %.6f (3 - e = %.6f)\n', d, f_ackley(zeros(1,d)), 3-exp(1));
end

fprintf('--- Funcion objetivo: inventario ---\n');
p = datos_inventario();
X = pob_inventario(200);
err = zeros(200,1);
for i = 1:200
    err(i) = abs(f_inventario(X(i,:),'integral') - f_inventario(X(i,:),'cerrada'));
end
fprintf('Max. diferencia integral vs forma cerrada (200 ind.): %.2e\n', max(err));
tic; for i = 1:200, f_inventario(X(i,:)); end
fprintf('Tiempo por evaluacion con integral: %.3f ms\n', 1000*toc/200);

fprintf('--- Poblaciones ---\n');
P = pob_viajero(100);
fprintf('Viajero: todas son permutaciones = %d\n', all(arrayfun(@(i) isequal(sort(P(i,:)),1:13), 1:100)));
A = pob_ackley(100, 5, [-10 10]);
fprintf('Ackley: tamano %dx%d, rango [%.2f, %.2f]\n', size(A), min(A(:)), max(A(:)));
k = p.n; Q = X(:,1:k); S = X(:,k+1:2*k); K = X(:,2*k+1:end);
fprintf('Inventario: max |sum(Q/2+S) - I| = %.2e\n', max(abs(sum(Q/2,2) + sum(S,2) - p.I)));
fprintf('Inventario: limites OK = %d\n', all(Q(:) >= p.Qmin & Q(:) <= p.Qmax) && ...
    all(all(S >= 0 & S <= p.Smax)) && all(all(K >= 0 & K <= p.Kmax)));

fprintf('--- Seleccion ---\n');
f = rand(40,1);
fprintf('Elitismo: %d ganadores, son los mejores = %d\n', numel(sel_elitismo(f)), ...
    isequal(sort(sel_elitismo(f)), sort(find(f <= median(f)))));
g = sel_torneo(f);
fprintf('Torneo: %d ganadores, sin repetidos = %d\n', numel(g), numel(unique(g)) == numel(g));
cuenta = zeros(4,1);
for r = 1:20000, w = sel_ruleta([1;2;4;8]); cuenta = cuenta + accumarray(w,1,[4 1]); end
fprintf('Ruleta con f = [1 2 4 8]: frecuencia = [%s], teorica = [%s]\n', ...
    num2str(cuenta'/sum(cuenta),3), num2str((1./[1 2 4 8])/sum(1./[1 2 4 8]),3));

fprintf('--- Cruce ---\n');
H = cruce_ox(pob_viajero(40));
fprintf('OX: todos los hijos son permutaciones = %d\n', all(arrayfun(@(i) isequal(sort(H(i,:)),1:13), 1:40)));
H = cruce_blx(pob_ackley(40, 3), 0.5, [-10 10]);
fprintf('BLX: hijos dentro de [-10, 10] = %d\n', all(abs(H(:)) <= 10));
H = cruce_aritmetico(pob_inventario(40));
fprintf('Aritmetico: max |sum(Q/2+S) - I| = %.2e\n', max(abs(sum(H(:,1:k)/2,2) + sum(H(:,k+1:2*k),2) - p.I)));

fprintf('--- Mutacion ---\n');
H = mut_viajero(pob_viajero(40), 1);
fprintf('Swap: siguen siendo permutaciones = %d\n', all(arrayfun(@(i) isequal(sort(H(i,:)),1:13), 1:40)));
H0 = pob_ackley(1000, 3); H = mut_ackley(H0, 0.3, 1, [-10 10]);
fprintf('Ackley: fraccion mutada = %.3f (Pm = 0.3)\n', mean(any(H ~= H0, 2)));
H0 = pob_inventario(1000); H = mut_inventario(H0, 0.3, 0.1);
fprintf('Inventario: fraccion mutada = %.3f, max |restriccion| = %.2e\n', mean(any(H ~= H0, 2)), ...
    max(abs(sum(H(:,1:k)/2,2) + sum(H(:,k+1:2*k),2) - p.I)));

fprintf('--- Corrida completa (100 iteraciones, torneo) ---\n');
op = struct('n', 60, 'iter', 100, 'seleccion', @sel_torneo, 'Pm', 0.2, 'sigma', 0.5);
r = algoritmo_genetico(definir_problema('viajero'), op);
fprintf('Viajero: %d min en %.2f s, ruta %s\n', r.mejor_f, r.tiempo, mat2str(r.mejor_x));
r = algoritmo_genetico(definir_problema('ackley', 3), op);
fprintf('Ackley d=3: %.6f en %.2f s\n', r.mejor_f, r.tiempo);
op.sigma = 0.05;
r = algoritmo_genetico(definir_problema('inventario'), op);
fprintf('Inventario: Z = %.4f en %.2f s\n', r.mejor_f, r.tiempo);
disp(reshape(r.mejor_x, 5, 3)');
