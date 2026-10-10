function ganadores = sel_torneo(fitness, tam_grupo, n_ganan)
% SEL_TORNEO Seleccion por torneo (minimizacion).
% Se forman grupos aleatorios de tam_grupo individuos (4 por defecto) sin
% repetir individuos entre grupos, y de cada grupo pasan los n_ganan
% mejores (2 por defecto). Se repite hasta tener la mitad de la poblacion.
if nargin < 2, tam_grupo = 4; end
if nargin < 3, n_ganan = 2;   end
n = numel(fitness);
orden = randperm(n);
n_grupos = floor(n/tam_grupo);
ganadores = zeros(n_grupos*n_ganan, 1);
for g = 1:n_grupos
    grupo = orden((g-1)*tam_grupo + (1:tam_grupo));
    [~, pos] = sort(fitness(grupo), 'ascend');
    ganadores((g-1)*n_ganan + (1:n_ganan)) = grupo(pos(1:n_ganan));
end
end
