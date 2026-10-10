function res = algoritmo_genetico(prob, op)
% ALGORITMO_GENETICO Algoritmo genetico generico de minimizacion.
% prob: estructura creada con definir_problema.
% op:   opciones
%   op.n          tamano de la poblacion (multiplo de 4)
%   op.iter       numero de generaciones (iteraciones)
%   op.seleccion  handle: @sel_elitismo, @sel_torneo o @sel_ruleta
%   op.Pm         probabilidad de mutacion por individuo
%   op.sigma      magnitud de la mutacion (sigma_m en Ackley, fraccion del
%                 rango en inventarios; se ignora en el viajero)
% res: mejor valor encontrado, mejor individuo, curva de convergencia
%      (mejor valor hasta cada generacion) y tiempo de ejecucion.
tic;
% 1. Poblacion inicial
pob = prob.poblacion(op.n);
fit = evaluar(prob, pob);
[mejor_f, im] = min(fit);
mejor_x = pob(im,:);
convergencia = zeros(op.iter + 1, 1);
convergencia(1) = mejor_f;
for g = 1:op.iter
    % 2. Seleccion: la mitad de la poblacion pasa y se aparea
    ganadores = op.seleccion(fit);
    ganadores = ganadores(randperm(numel(ganadores)));   % parejas al azar
    padres = pob(ganadores,:);
    % 3. Cruce: cada pareja genera 2 hijos (la otra mitad de la poblacion)
    hijos = prob.cruce(padres);
    % 4. Mutacion de los hijos
    hijos = prob.mutacion(hijos, op.Pm, op.sigma);
    % 5. Nueva generacion = padres seleccionados + hijos
    fit_hijos = evaluar(prob, hijos);
    pob = [padres; hijos];
    fit = [fit(ganadores); fit_hijos];
    % Se guarda el mejor individuo encontrado hasta el momento
    [f_gen, im] = min(fit);
    if f_gen < mejor_f
        mejor_f = f_gen;
        mejor_x = pob(im,:);
    end
    convergencia(g + 1) = mejor_f;
end
res.mejor_f = mejor_f;
res.mejor_x = mejor_x;
res.convergencia = convergencia;
res.tiempo = toc;
end

function fit = evaluar(prob, pob)
fit = zeros(size(pob, 1), 1);
for i = 1:size(pob, 1)
    fit(i) = prob.fitness(pob(i,:));
end
end
