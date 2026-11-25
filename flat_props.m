function L = flat_props(S, pre)
L = {};
f = fieldnames(S);
for i = 1:numel(f)
    v = S.(f{i});
    nm = [pre f{i}];
    if isstruct(v)
        L = [L, flat_props(v, [nm '.'])];      %#ok<AGROW>
    elseif isnumeric(v) && ~isempty(v) && numel(v) <= 4
        s = sprintf('%.5g ', v);
        L{end+1} = sprintf('%-13s= %s', nm(1:min(end, 13)), strtrim(s));   %#ok<AGROW>
    end
end
end

