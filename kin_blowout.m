function tBO = kin_blowout(S, nstart, thr)
% blowout residence time: smallest tau for which the ignited WSR state survives
% (bisection in log tau), the same idea as KINETX
lo = 1e-7;
hi = 1e-2;
if kin_lit(S, lo, nstart, thr)
    tBO = lo;
    warning('Flame survives at the smallest residence time tested (1e-7 s).');
    return
end
if ~kin_lit(S, hi, nstart, thr)
    tBO = NaN;
    warning('No stable ignited solution up to 10 ms.');
    return
end
for it = 1:24
    mid = sqrt(lo*hi);
    if kin_lit(S, mid, nstart, thr)
        hi = mid;
    else
        lo = mid;
    end
    if hi/lo < 1.02
        break
    end
end
tBO = sqrt(lo*hi);
end

