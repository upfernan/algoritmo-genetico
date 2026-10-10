function prob = definir_problema(nombre, d)
% DEFINIR_PROBLEMA Agrupa en una estructura las funciones de cada caso:
%   prob.fitness(x)            -> aptitud de un individuo (fila)
%   prob.poblacion(n)          -> poblacion inicial de n individuos
%   prob.cruce(padres)         -> hijos (mismo numero de filas que padres)
%   prob.mutacion(h, Pm, sig)  -> hijos mutados
% nombre: 'viajero', 'ackley' o 'inventario'. d: dimensiones (Ackley).
if nargin < 2, d = 3; end
lim = [-10 10];
switch lower(nombre)
    case 'viajero'
        prob.fitness   = @f_viajero;
        prob.poblacion = @(n) pob_viajero(n, 13);
        prob.cruce     = @cruce_ox;
        prob.mutacion  = @(h, Pm, sig) mut_viajero(h, Pm);
    case 'ackley'
        prob.fitness   = @f_ackley;
        prob.poblacion = @(n) pob_ackley(n, d, lim);
        prob.cruce     = @(p) cruce_blx(p, 0.5, lim);
        prob.mutacion  = @(h, Pm, sig) mut_ackley(h, Pm, sig, lim);
        prob.optimo    = 3 - exp(1);
    case 'inventario'
        prob.fitness   = @f_inventario;
        prob.poblacion = @pob_inventario;
        prob.cruce     = @cruce_aritmetico;
        prob.mutacion  = @mut_inventario;
    otherwise
        error('Problema desconocido: %s', nombre);
end
prob.nombre = lower(nombre);
end
