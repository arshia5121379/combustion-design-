function arrow2d(x1, y1, x2, y2, hs, col, lw)
% straight arrow with a filled head (hs = head length in data units)
d = [x2 - x1, y2 - y1];
L = hypot(d(1), d(2));
if L < eps
    return
end
d = d/L;
nv = [-d(2), d(1)];
hs = min(hs, 0.45*L);
xb = x2 - hs*d(1);
yb = y2 - hs*d(2);
plot([x1 xb], [y1 yb], '-', 'Color', col, 'LineWidth', lw);
fill([x2, xb + 0.35*hs*nv(1), xb - 0.35*hs*nv(1)], ...
     [y2, yb + 0.35*hs*nv(2), yb - 0.35*hs*nv(2)], col, 'EdgeColor', col);
end

