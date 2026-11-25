function [idx, cf, hasM] = parse_side(str, sp)
% parse one side of a reaction string: species with optional coefficient
tok = strtrim(strsplit(str, '+'));
idx = zeros(0, 1);
cf = zeros(0, 1);
hasM = false;
for t = 1:numel(tok)
    w = strtrim(tok{t});
    c = 1;
    m = regexp(w, '^(\d+)\s+(\S+)$', 'tokens', 'once');
    if ~isempty(m)
        c = str2double(m{1});
        w = m{2};
    end
    if strcmp(w, 'M')
        hasM = true;
        continue
    end
    k = find(strcmp(sp, w), 1);
    if isempty(k)
        error('Unknown species "%s" in the mechanism.', w);
    end
    idx(end + 1, 1) = k;                                %#ok<AGROW>
    cf(end + 1, 1) = c;                                 %#ok<AGROW>
end
end

