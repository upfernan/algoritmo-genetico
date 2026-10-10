function generar_salidas()
% GENERAR_SALIDAS Crea las tablas (LaTeX) y figuras del informe a partir de
% los resultados guardados por experimentos.m.
res = fullfile('..', 'resultados');
tab = fullfile('..', 'informe', 'tablas');
fig = fullfile('..', 'informe', 'figuras');
if ~exist(tab, 'dir'), mkdir(tab); end
if ~exist(fig, 'dir'), mkdir(fig); end
load(fullfile(res, 'E1.mat'), 'E1', 'nombres_sel', 'optimos');
load(fullfile(res, 'E2.mat'), 'E2', 'iteraciones');
load(fullfile(res, 'E3.mat'), 'E3');
load(fullfile(res, 'E4.mat'), 'E4', 'dimensiones', 'decision');

% ---------------- Estudio 1: seleccion ----------------
tabla_viajero(fullfile(tab, 't1_viajero.tex'), E1.viajero, nombres_sel, 'M\''etodo', ...
    'Estudio 1 -- problema del viajero: m\''etodo de selecci\''on (100 iteraciones).', 'tab:t1v');
tabla_ackley(fullfile(tab, 't1_ackley.tex'), E1.ackley, nombres_sel, 'M\''etodo', ...
    'Estudio 1 -- funci\''on Ackley ($d=3$): m\''etodo de selecci\''on (100 iteraciones).', 'tab:t1a');
tabla_inventario(fullfile(tab, 't1_inventario.tex'), E1.inventario, nombres_sel, 'M\''etodo', ...
    'Estudio 1 -- inventarios: m\''etodo de selecci\''on (100 iteraciones).', 'tab:t1i');

% ---------------- Estudio 2: iteraciones ----------------
et = arrayfun(@num2str, iteraciones, 'UniformOutput', false);
tabla_viajero(fullfile(tab, 't2_viajero.tex'), E2.viajero, et, 'Iter.', ...
    'Estudio 2 -- problema del viajero: n\''umero de iteraciones (selecci\''on por elitismo).', 'tab:t2v');
tabla_ackley(fullfile(tab, 't2_ackley.tex'), E2.ackley, et, 'Iter.', ...
    'Estudio 2 -- funci\''on Ackley ($d=3$): n\''umero de iteraciones (selecci\''on por elitismo).', 'tab:t2a');
tabla_inventario(fullfile(tab, 't2_inventario.tex'), E2.inventario, et, 'Iter.', ...
    'Estudio 2 -- inventarios: n\''umero de iteraciones (selecci\''on por elitismo).', 'tab:t2i');

% ---------------- Estudio 3: mutacion ----------------
etv = arrayfun(@(r) sprintf('%.2f', r.op.Pm), E3.viajero, 'UniformOutput', false);
tabla_viajero(fullfile(tab, 't3_viajero.tex'), E3.viajero, etv, '$P_m$', ...
    'Estudio 3 -- problema del viajero: probabilidad de mutaci\''on $P_m$ (elitismo, 50 iteraciones).', 'tab:t3v', false);
eta = arrayfun(@(r) sprintf('%.2f / %.1f', r.op.Pm, r.op.sigma), E3.ackley, 'UniformOutput', false);
tabla_ackley(fullfile(tab, 't3_ackley.tex'), E3.ackley, eta, '$P_m$ / $\sigma_m$', ...
    'Estudio 3 -- funci\''on Ackley ($d=3$): probabilidad $P_m$ y magnitud $\sigma_m$ de la mutaci\''on (elitismo, 50 iteraciones).', 'tab:t3a', false);
eti = arrayfun(@(r) sprintf('%.2f / %.2f', r.op.Pm, r.op.sigma), E3.inventario, 'UniformOutput', false);
tabla_inventario(fullfile(tab, 't3_inventario.tex'), E3.inventario, eti, '$P_m$ / $\sigma_r$', ...
    'Estudio 3 -- inventarios: probabilidad $P_m$ y magnitud relativa $\sigma_r$ de la mutaci\''on (elitismo, 200 iteraciones).', 'tab:t3i', false);

% ---------------- Estudio 4: dimensiones ----------------
fid = fopen(fullfile(tab, 't4_ackley.tex'), 'w');
fprintf(fid, '%% Generado automaticamente por generar_salidas.m\n');
fprintf(fid, '\\begin{table}[!t]\n\\centering\n\\scriptsize\n\\setlength{\\tabcolsep}{3pt}\n');
fprintf(fid, '\\caption{Estudio 4 -- funci\\''on Ackley: n\\''umero de dimensiones (elitismo, %d iteraciones, $P_m=%.2f$, $\\sigma_m=%.1f$).}\n', ...
    decision.ackley.iter, decision.ackley.Pm, decision.ackley.sigma);
fprintf(fid, '\\label{tab:t4a}\n\\begin{tabular}{rrrrrrr}\n\\hline\n');
fprintf(fid, '$d$ & $t$ (ms) & $f(\\hat{X})$ & Prom. & Desv. & RMSE & $\\|\\hat{X}\\|_\\infty$ \\\\\n\\hline\n');
for k = 1:numel(E4)
    r = E4(k);
    fprintf(fid, '%d & %.2f & %.4f & %.4f & %s & %s & %s \\\\\n', dimensiones(k), 1000*r.tiempo, ...
        r.mejor_f, r.promedio, sci(r.desv), sci(r.rmse), sci(max(abs(r.mejor_x))));
end
fprintf(fid, '\\hline\n\\end{tabular}\n\\end{table}\n');
fclose(fid);
% Individuos completos del estudio 4 (anexo)
fid = fopen(fullfile(res, 'estudio4_mejores_individuos.csv'), 'w');
for k = 1:numel(E4)
    fprintf(fid, 'd=%d,%s\n', dimensiones(k), strjoin(arrayfun(@(v) sprintf('%.6g', v), E4(k).mejor_x, 'UniformOutput', false), ','));
end
fclose(fid);

% ---------------- Figuras ----------------
nombres_prob = {'viajero', 'ackley', 'inventario'};
titulos = {'Problema del viajero', 'Funci\''on Ackley ($d=3$)', 'Inventarios'};
ylab = {'Tiempo (min)', '$f(\hat{X})$', '$Z$'};
ylab_conv = {'Tiempo (min)', '$f(\hat{X}) - (3-e)$', '$Z$'};
f = figure('Visible', 'off', 'Theme', 'light', 'Units', 'centimeters', 'Position', [0 0 8.8 14]);
tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
for ip = 1:3
    nexttile; hold on; box on; grid on;
    for is = 1:3
        c = E1.(nombres_prob{ip})(is).conv;
        if ip == 2, c = c - (3 - exp(1)); end   % error respecto al optimo
        plot(0:size(c,1)-1, mean(c, 2), 'LineWidth', 1.2);
    end
    if ip == 2, set(gca, 'YScale', 'log'); end
    title(titulos{ip}, 'Interpreter', 'latex', 'FontSize', 9);
    ylabel(ylab_conv{ip}, 'Interpreter', 'latex');
    if ip == 1, legend(nombres_sel, 'Location', 'northeast', 'FontSize', 7); end
end
xlabel(tl, 'Generaci\''on', 'Interpreter', 'latex');
exportgraphics(f, fullfile(fig, 'convergencia_seleccion.pdf'), 'ContentType', 'vector');
exportgraphics(f, fullfile(res, 'convergencia_seleccion.png'), 'Resolution', 150);
close(f);

f = figure('Visible', 'off', 'Theme', 'light', 'Units', 'centimeters', 'Position', [0 0 8.8 12]);
tl = tiledlayout(3, 1, 'TileSpacing', 'compact', 'Padding', 'compact');
for ip = 1:3
    R = E3.(nombres_prob{ip})(1:7);
    nexttile; box on; grid on; hold on;
    errorbar([0 0.05 0.1 0.2 0.4 0.7 1.0], [R.promedio], [R.desv], 'o-', 'LineWidth', 1.1, 'MarkerSize', 4);
    title(titulos{ip}, 'Interpreter', 'latex', 'FontSize', 9);
    ylabel(ylab{ip}, 'Interpreter', 'latex');
end
xlabel(tl, 'Probabilidad de mutaci\''on $P_m$', 'Interpreter', 'latex');
exportgraphics(f, fullfile(fig, 'efecto_pm.pdf'), 'ContentType', 'vector');
exportgraphics(f, fullfile(res, 'efecto_pm.png'), 'Resolution', 150);
close(f);

f = figure('Visible', 'off', 'Theme', 'light', 'Units', 'centimeters', 'Position', [0 0 8.8 6]);
errorbar(dimensiones, [E4.promedio], [E4.desv], 'o-', 'LineWidth', 1.2, 'MarkerSize', 4); hold on;
yline(3 - exp(1), '--', '$3-e$', 'Interpreter', 'latex');
set(gca, 'XScale', 'log'); grid on; box on;
xlabel('N\''umero de dimensiones $d$', 'Interpreter', 'latex');
ylabel('$f(\hat{X})$ promedio', 'Interpreter', 'latex');
exportgraphics(f, fullfile(fig, 'dimensiones.pdf'), 'ContentType', 'vector');
exportgraphics(f, fullfile(res, 'dimensiones.png'), 'Resolution', 150);
close(f);
fprintf('Tablas y figuras generadas.\n');
end

% ======================================================================
function tabla_viajero(archivo, R, etiquetas, col, caption, label, con_tiempo)
if nargin < 7, con_tiempo = true; end
fid = fopen(archivo, 'w');
fprintf(fid, '%% Generado automaticamente por generar_salidas.m\n');
fprintf(fid, '\\begin{table}[!t]\n\\centering\n\\scriptsize\n\\setlength{\\tabcolsep}{2.5pt}\n');
fprintf(fid, '\\caption{%s}\n\\label{%s}\n', caption, label);
if con_tiempo
    fprintf(fid, '\\begin{tabular}{lrrrrrl}\n\\hline\n');
    fprintf(fid, '%s & $t$ (ms) & $f(\\hat{X})$ & Prom. & Desv. & RMSE$^*$ & $\\hat{X}$ (ruta) \\\\\n\\hline\n', col);
else
    fprintf(fid, '\\begin{tabular}{lrrrrl}\n\\hline\n');
    fprintf(fid, '%s & $f(\\hat{X})$ & Prom. & Desv. & RMSE$^*$ & $\\hat{X}$ (ruta) \\\\\n\\hline\n', col);
end
for k = 1:numel(R)
    ruta = strjoin(arrayfun(@num2str, R(k).mejor_x, 'UniformOutput', false), '-');
    if con_tiempo
        fprintf(fid, '%s & %.1f & %d & %.1f & %.2f & %.2f & %s \\\\\n', etiquetas{k}, ...
            1000*R(k).tiempo, R(k).mejor_f, R(k).promedio, R(k).desv, R(k).rmse, ruta);
    else
        fprintf(fid, '%s & %d & %.1f & %.2f & %.2f & %s \\\\\n', etiquetas{k}, ...
            R(k).mejor_f, R(k).promedio, R(k).desv, R(k).rmse, ruta);
    end
end
fprintf(fid, '\\hline\n\\multicolumn{%d}{l}{$^*$RMSE respecto al \\''optimo exacto (509 min, Held-Karp).}\n', 6 + con_tiempo);
fprintf(fid, '\\end{tabular}\n\\end{table}\n');
fclose(fid);
end

function tabla_ackley(archivo, R, etiquetas, col, caption, label, con_tiempo)
if nargin < 7, con_tiempo = true; end
fid = fopen(archivo, 'w');
fprintf(fid, '%% Generado automaticamente por generar_salidas.m\n');
fprintf(fid, '\\begin{table*}[!t]\n\\centering\n\\scriptsize\n\\setlength{\\tabcolsep}{2.5pt}\n');
fprintf(fid, '\\caption{%s}\n\\label{%s}\n', caption, label);
if con_tiempo
    fprintf(fid, '\\begin{tabular}{lrrrrrl}\n\\hline\n');
    fprintf(fid, '%s & $t$ (ms) & $f(\\hat{X})$ & Prom. & Desv. & RMSE & $\\hat{X}$ \\\\\n\\hline\n', col);
else
    fprintf(fid, '\\begin{tabular}{lrrrrl}\n\\hline\n');
    fprintf(fid, '%s & $f(\\hat{X})$ & Prom. & Desv. & RMSE & $\\hat{X}$ \\\\\n\\hline\n', col);
end
for k = 1:numel(R)
    x = ['(' strjoin(arrayfun(@sci, R(k).mejor_x, 'UniformOutput', false), ', ') ')'];
    if con_tiempo
        fprintf(fid, '%s & %.2f & %.6f & %.6f & %s & %s & %s \\\\\n', etiquetas{k}, 1000*R(k).tiempo, ...
            R(k).mejor_f, R(k).promedio, sci(R(k).desv), sci(R(k).rmse), x);
    else
        fprintf(fid, '%s & %.6f & %.6f & %s & %s & %s \\\\\n', etiquetas{k}, ...
            R(k).mejor_f, R(k).promedio, sci(R(k).desv), sci(R(k).rmse), x);
    end
end
fprintf(fid, '\\hline\n\\end{tabular}\n\\end{table*}\n');
fclose(fid);
end

function tabla_inventario(archivo, R, etiquetas, col, caption, label, con_tiempo)
if nargin < 7, con_tiempo = true; end
fid = fopen(archivo, 'w');
fprintf(fid, '%% Generado automaticamente por generar_salidas.m\n');
fprintf(fid, '\\begin{table*}[!t]\n\\centering\n\\scriptsize\n\\setlength{\\tabcolsep}{3pt}\n');
fprintf(fid, '\\caption{%s Valores monetarios en miles de COP.}\n\\label{%s}\n', caption, label);
if con_tiempo
    fprintf(fid, '\\begin{tabular}{lrrrrlll}\n\\hline\n');
    fprintf(fid, '%s & $t$ (s) & $f(\\hat{X})$ & Prom. & Desv. & $\\hat{Q}$ & $\\hat{S}$ & $\\hat{K}$ \\\\\n\\hline\n', col);
else
    fprintf(fid, '\\begin{tabular}{lrrrlll}\n\\hline\n');
    fprintf(fid, '%s & $f(\\hat{X})$ & Prom. & Desv. & $\\hat{Q}$ & $\\hat{S}$ & $\\hat{K}$ \\\\\n\\hline\n', col);
end
for k = 1:numel(R)
    x = R(k).mejor_x;
    v = @(a) ['(' strjoin(arrayfun(@(y) sprintf('%.0f', y), a, 'UniformOutput', false), ', ') ')'];
    if con_tiempo
        fprintf(fid, '%s & %.2f & %.2f & %.2f & %.2f & %s & %s & %s \\\\\n', etiquetas{k}, R(k).tiempo, ...
            R(k).mejor_f, R(k).promedio, R(k).desv, v(x(1:5)), v(x(6:10)), v(x(11:15)));
    else
        fprintf(fid, '%s & %.2f & %.2f & %.2f & %s & %s & %s \\\\\n', etiquetas{k}, ...
            R(k).mejor_f, R(k).promedio, R(k).desv, v(x(1:5)), v(x(6:10)), v(x(11:15)));
    end
end
fprintf(fid, '\\hline\n\\end{tabular}\n\\end{table*}\n');
fclose(fid);
end

function s = sci(x)
% Numero en notacion cientifica compacta para LaTeX
if x == 0
    s = '0';
elseif abs(x) >= 1e-2 && abs(x) < 1e3
    s = sprintf('%.3f', x);
else
    e = floor(log10(abs(x)));
    s = sprintf('$%.2f{\\times}10^{%d}$', x/10^e, e);
end
end
