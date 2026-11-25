function L = prop_lines(R, isAB)
% every scalar input / result of the selected burner as 'name = value' lines
L = {};
if isAB && isfield(R, 'ab')
    X = R.ab; tag = 'AFTERBURNER';
elseif ~isAB && isfield(R, 'main')
    X = R.main; tag = 'MAIN BURNER';
else
    return
end
L{end+1} = sprintf('%s  (SI units: m, m^2, Pa, K, kg/s, s)', tag);
L{end+1} = '--- INPUTS ---';
L = [L, flat_props(X.in, '')];
L{end+1} = '--- CALCULATED ---';
L = [L, flat_props(X.res, '')];
if isAB
    if isfield(X, 'grid') && ~isempty(X.grid)
        L{end+1} = '--- DIFFUSER GRID ---';
        L = [L, flat_props(X.grid, 'gs.')];
    end
    if isfield(X, 'nomix') && ~isempty(X.nomix)
        L{end+1} = '--- NO-MIX DESIGN ---';
        L = [L, flat_props(X.nomix, 'nm.')];
    end
else
    L{end+1} = '--- SECONDARY HOLES ---';
    L = [L, flat_props(X.holes_sec, 'sec.')];
    L{end+1} = '--- DILUTION HOLES ---';
    L = [L, flat_props(X.holes_dil, 'dil.')];
end
if isfield(X, 'kin') && isstruct(X.kin)
    L{end+1} = '--- KINETICS ---';
    L = [L, flat_props(X.kin, 'kin.')];
end
end

