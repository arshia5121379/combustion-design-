function write_polys(fid, name, G)
f = fieldnames(G);
for i = 1:numel(f)
    v = G.(f{i});
    if ~isnumeric(v) || size(v, 2) ~= 2
        continue
    end
    for k = 1:size(v, 1)
        if any(isnan(v(k, :)))
            continue
        end
        fprintf(fid, '%s,%s,%.4f,%.4f\n', name, f{i}, v(k, 1), v(k, 2));
    end
end
end

%% ======================================================================
%%  DIFFUSER GRID SEARCH  (Eqs. 9.102-9.104, 9.127)
%% ======================================================================
