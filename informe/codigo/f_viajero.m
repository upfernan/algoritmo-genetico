function t = f_viajero(ruta)
% F_VIAJERO Funcion objetivo del problema del viajero.
% Recibe una lista con los numeros 1..13 (orden de visita) y retorna el
% tiempo total del recorrido en minutos, INCLUYENDO el regreso al punto
% de partida (ciclo cerrado). Ej.: f_viajero(1:13) = 730 (641 + 89).
% Si la lista no es una permutacion de 1..13 se penaliza sumando 10000
% (la suma de todos los tiempos de la tabla es 9534).
persistent T
if isempty(T)
    T = datos_viajero();
end
n = size(T,1);
ruta = round(ruta(:)');
penalizacion = 0;
if numel(ruta) ~= n || ~isequal(sort(ruta), 1:n)
    penalizacion = 10000;
    ruta = min(max(ruta,1),n);   % se evita indexar fuera de la tabla
end
siguiente = [ruta(2:end), ruta(1)];
t = sum(T(sub2ind(size(T), ruta, siguiente))) + penalizacion;
end
