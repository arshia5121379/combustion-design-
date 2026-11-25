function ax = subax(nr, nc, k)
% subplot with generous, fixed margins so titles / labels / ticks never collide
col = mod(k - 1, nc);
row = floor((k - 1)/nc);
mL = 0.09; mR = 0.04; mB = 0.13; mT = 0.08; gx = 0.09; gy = 0.17;
w = (1 - mL - mR - (nc - 1)*gx)/nc;
h = (1 - mB - mT - (nr - 1)*gy)/nr;
ax = axes('Position', [mL + col*(w + gx), 1 - mT - (row + 1)*h - row*gy, w, h]);
box on;
end

