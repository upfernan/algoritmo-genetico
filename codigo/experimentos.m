function experimentos(etapa)
% EXPERIMENTOS Estudios del informe (seccion 3.5 de la guia). Cada etapa
% guarda sus resultados en ../resultados y usa las decisiones de la etapa
% anterior, por eso deben ejecutarse en orden: 1, 2, 3 y 4.
%   1: metodo de seleccion (100 iteraciones)
%   2: numero de iteraciones (10, 20, 30, 50, 100, 150, 200)
%   3: estrategia de mutacion (Pm y magnitud de la mutacion)
%   4: numero de dimensiones de Ackley (2, 3, 10, 20, 50, 100)
carpeta = fullfile('..', 'resultados');
if ~exist(carpeta, 'dir'), mkdir(carpeta); end
N_PRUEBAS = 10;             % pruebas por escenario (la guia pide >= 5)
N_POB     = 60;             % tamano de poblacion (multiplo de 4)
D_ACKLEY  = 3;              % dimensiones de Ackley en los estudios 1-3
problemas = {'viajero', 'ackley', 'inventario'};
% Configuracion base (antes de los estudios)
base.viajero    = struct('n', N_POB, 'iter', 100, 'Pm', 0.2, 'sigma', 0);
base.ackley     = struct('n', N_POB, 'iter', 100, 'Pm', 0.2, 'sigma', 0.5);
base.inventario = struct('n', N_POB, 'iter', 100, 'Pm', 0.2, 'sigma', 0.05);
optimos.viajero = viajero_exacto();       % referencia (Held-Karp)
optimos.ackley = 3 - exp(1);
optimos.inventario = NaN;                 % desconocido
selecciones = {@sel_elitismo, @sel_torneo, @sel_ruleta};
nombres_sel = {'Elitismo', 'Torneo', 'Ruleta'};

switch etapa
    case 1
        for ip = 1:3
            nom = problemas{ip};
            prob = definir_problema(nom, D_ACKLEY);
            for is = 1:3
                op = base.(nom); op.seleccion = selecciones{is};
                E1.(nom)(is) = correr_escenario(prob, op, N_PRUEBAS, optimos.(nom));
                imprimir(nom, nombres_sel{is}, E1.(nom)(is));
            end
            % Criterio: menor promedio; empate -> menor desviacion
            [~, orden] = sortrows([[E1.(nom).promedio]', [E1.(nom).desv]']);
            decision.(nom).seleccion = selecciones{orden(1)};
            decision.(nom).nombre_sel = nombres_sel{orden(1)};
            fprintf('==> %s: mejor seleccion = %s\n', nom, nombres_sel{orden(1)});
        end
        save(fullfile(carpeta, 'E1.mat'), 'E1', 'decision', 'nombres_sel', 'optimos', 'base', 'N_PRUEBAS', 'N_POB', 'D_ACKLEY');

    case 2
        load(fullfile(carpeta, 'E1.mat'), 'decision', 'optimos', 'base', 'N_PRUEBAS', 'D_ACKLEY');
        iteraciones = [10 20 30 50 100 150 200];
        for ip = 1:3
            nom = problemas{ip};
            prob = definir_problema(nom, D_ACKLEY);
            for ii = 1:numel(iteraciones)
                op = base.(nom); op.seleccion = decision.(nom).seleccion;
                op.iter = iteraciones(ii);
                E2.(nom)(ii) = correr_escenario(prob, op, N_PRUEBAS, optimos.(nom));
                imprimir(nom, sprintf('%d iter', iteraciones(ii)), E2.(nom)(ii));
            end
            % Criterio: el menor numero de iteraciones cuyo promedio este a
            % menos del 1 % del mejor promedio obtenido
            prom = [E2.(nom).promedio];
            ok = find(prom <= min(prom) + 0.01*abs(min(prom)), 1, 'first');
            decision.(nom).iter = iteraciones(ok);
            fprintf('==> %s: iteraciones escogidas = %d\n', nom, iteraciones(ok));
        end
        save(fullfile(carpeta, 'E2.mat'), 'E2', 'decision', 'iteraciones');

    case 3
        load(fullfile(carpeta, 'E1.mat'), 'optimos', 'base', 'N_PRUEBAS', 'D_ACKLEY');
        load(fullfile(carpeta, 'E2.mat'), 'decision');
        valores_Pm = [0 0.05 0.1 0.2 0.4 0.7 1.0];
        valores_sigma.viajero    = 0;
        valores_sigma.ackley     = [0.1 0.5 1 2];
        valores_sigma.inventario = [0.01 0.05 0.1 0.2];
        for ip = 1:3
            nom = problemas{ip};
            prob = definir_problema(nom, D_ACKLEY);
            % Parte A: se varia Pm con la magnitud base
            for k = 1:numel(valores_Pm)
                op = base.(nom); op.seleccion = decision.(nom).seleccion;
                op.iter = decision.(nom).iter; op.Pm = valores_Pm(k);
                E3.(nom)(k) = correr_escenario(prob, op, N_PRUEBAS, optimos.(nom));
                imprimir(nom, sprintf('Pm=%.2f sig=%.2f', op.Pm, op.sigma), E3.(nom)(k));
            end
            % Pm = 0 es el escenario de control (sin mutacion): no se escoge
            candidatos = find(valores_Pm > 0);
            [~, orden] = sortrows([[E3.(nom)(candidatos).promedio]', [E3.(nom)(candidatos).desv]']);
            mejor_Pm = E3.(nom)(candidatos(orden(1))).op.Pm;
            % Parte B: con el mejor Pm se varia la magnitud de la mutacion
            if numel(valores_sigma.(nom)) > 1
                for s = valores_sigma.(nom)
                    if s == base.(nom).sigma, continue; end
                    op = base.(nom); op.seleccion = decision.(nom).seleccion;
                    op.iter = decision.(nom).iter; op.Pm = mejor_Pm; op.sigma = s;
                    E3.(nom)(end+1) = correr_escenario(prob, op, N_PRUEBAS, optimos.(nom));
                    imprimir(nom, sprintf('Pm=%.2f sig=%.2f', op.Pm, op.sigma), E3.(nom)(end));
                end
            end
            candidatos = [2:numel(valores_Pm), numel(valores_Pm)+1:numel(E3.(nom))];
            [~, orden] = sortrows([[E3.(nom)(candidatos).promedio]', [E3.(nom)(candidatos).desv]']);
            decision.(nom).Pm = E3.(nom)(candidatos(orden(1))).op.Pm;
            decision.(nom).sigma = E3.(nom)(candidatos(orden(1))).op.sigma;
            fprintf('==> %s: Pm = %.2f, sigma = %.2f\n', nom, decision.(nom).Pm, decision.(nom).sigma);
        end
        save(fullfile(carpeta, 'E3.mat'), 'E3', 'decision', 'valores_Pm', 'valores_sigma');

    case 4
        load(fullfile(carpeta, 'E1.mat'), 'optimos', 'base', 'N_PRUEBAS');
        load(fullfile(carpeta, 'E3.mat'), 'decision');
        dimensiones = [2 3 10 20 50 100];
        for id = 1:numel(dimensiones)
            prob = definir_problema('ackley', dimensiones(id));
            op = base.ackley; op.seleccion = decision.ackley.seleccion;
            op.iter = decision.ackley.iter; op.Pm = decision.ackley.Pm;
            op.sigma = decision.ackley.sigma;
            E4(id) = correr_escenario(prob, op, N_PRUEBAS, optimos.ackley); %#ok<AGROW>
            imprimir('ackley', sprintf('d=%d', dimensiones(id)), E4(id));
        end
        save(fullfile(carpeta, 'E4.mat'), 'E4', 'decision', 'dimensiones');
end
end

function imprimir(nom, etiqueta, r)
fprintf('%-10s %-20s t=%7.3fs  mejor=%10.4f  prom=%10.4f  desv=%9.4f  rmse=%9.4f\n', ...
    nom, etiqueta, r.tiempo, r.mejor_f, r.promedio, r.desv, r.rmse);
end
