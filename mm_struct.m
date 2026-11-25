function G = mm_struct(G)
% convert geometry from metres to millimetres (polylines and scalars)
f = fieldnames(G);
for i = 1:numel(f)
    v = G.(f{i});
    if isnumeric(v)
        G.(f{i}) = 1e3*v;
    end
end
end

%% ======================================================================
%%  FIGURE HELPERS  (every figure gets its own, non-overlapping window,
%%  a fixed size, and is also saved as a PNG in .\Combustor_Figures)
%% ======================================================================
