function fig_jets(M, kfig)
r = M.res; Hs = M.holes_sec; Hd = M.holes_dil; I = M.in;
HL = r.HL*1e3; Hr = r.H32*1e3;
Lpz = r.Lpz*1e3; Lsz = r.Lsz*1e3; Ldz = r.Ldz*1e3; Ltr = r.Ltr*1e3;
rm = r.rm32*1e3; yo4 = r.ro4*1e3 - rm; yi4 = r.ri4*1e3 - rm;
tg = r.Tg/I.Tt32;
UA1 = r.Ur*r.muA/(1 - r.alpha);                      % annulus velocity before the secondary holes
UA2 = r.Ur*r.mu_dz/(1 - r.alpha);                    % annulus velocity before the dilution holes
UPZ = r.Ur*tg*r.mu_pz/r.alpha;                       % liner velocity in the primary zone
USZ = r.Ur*tg*(r.mu_pz + r.mu_sz)/r.alpha;           % liner velocity after the secondary jets
xs = Lpz; xd = Lpz + Lsz; xL = xd + Ldz; x4 = xL + Ltr;
yl = HL/2; yc = Hr/2;
if kfig == 1
    nm = 'Fig. 9.33 - secondary zone air jet trajectories and nomenclature';
    fn = 'fig_9_33_secondary_zone';
    xw = [-0.75*HL, xd + 0.25*HL];
else
    nm = 'Fig. 9.34 - dilution zone air jets, liner and transition duct';
    fn = 'fig_9_34_dilution_zone';
    xw = [xs - 0.25*Lsz, x4 + 0.1*Ltr];
end
W = xw(2) - xw(1);
fh = newfig(nm, 1250, 600);
hold on;
cK = [0.10 0.10 0.10]; cB = [0.05 0.30 0.70]; cR = [0.80 0.10 0.10];
xa = xw(1);
% casings and liner
plot([xa 0 xL x4], [yc yc yc yo4], 'k-', 'LineWidth', 2.4);
plot([xa 0 xL x4], [-yc -yc -yc yi4], 'k-', 'LineWidth', 2.4);
plot([0 xL], [yl yl], 'k-', 'LineWidth', 1.8);
plot([0 xL], [-yl -yl], 'k-', 'LineWidth', 1.8);
plot([xL x4], [yl yo4], 'k-', 'LineWidth', 1.8);
plot([xL x4], [-yl yi4], 'k-', 'LineWidth', 1.8);
t = linspace(pi/2, 3*pi/2, 60);
plot(0.45*yl*cos(t), yl*sin(t), 'k-', 'LineWidth', 1.8);          % dome
plot([xs xs], [-yl yl], ':', 'Color', [0.5 0.5 0.5]);
plot([xd xd], [-yl yl], ':', 'Color', [0.5 0.5 0.5]);
plot([xL xL], [-yl yl], ':', 'Color', [0.5 0.5 0.5]);
% jets: centre line and a widening envelope, penetration = H_L/4 (secondary), H_L/3 (dilution)
jetspec = {xs, Lsz, HL/4, Hs.dj*1e3; xd, Ldz, HL/3, Hd.dj*1e3};
if kfig == 1
    qlist = 1;                       % dilution jets lie outside this window
else
    qlist = [1 2];
end
for q = qlist
    xj = jetspec{q, 1}; Lj = jetspec{q, 2}; ym = jetspec{q, 3}; dj = jetspec{q, 4};
    s = linspace(0, Lj, 80);
    ycl = ym*(1 - exp(-s/(0.9*ym)));
    for sg = [1 -1]
        plot(xj + s, sg*(yl - ycl), '--', 'Color', cB, 'LineWidth', 1.3);
        plot(xj + s, sg*(yl - ycl - 0.5*dj - 0.10*s), ':', 'Color', cB);
        plot(xj + s, sg*(yl - ycl + 0.5*dj + 0.10*s), ':', 'Color', cB);
        plot(xj, sg*yl, 's', 'MarkerFaceColor', cR, 'MarkerEdgeColor', cR, 'MarkerSize', 5);
    end
    xdm = xj + 0.80*Lj;
    dim_v(xdm, yl, yl - ym, '', 0.07*HL);
    if q == 1
        lab = 'Y_{max} = H_L/4';
    else
        lab = 'Y_{max} = H_L/3';
    end
    text(xdm + 0.01*W, yl - 0.5*ym, lab, 'FontSize', 9, 'BackgroundColor', 'w', 'Margin', 1);
end
% velocity arrows
yann = 0.5*(yl + yc);
if kfig == 1
    arrow2d(0.08*xs, yann, 0.9*xs, yann, 0.2*HL, cK, 2);
    arrow2d(0.12*xs, 0, 0.8*xs, 0, 0.2*HL, cK, 2);
    text(0.5*xs, yc + 0.03*Hr, sprintf('U_A \\approx %.1f m/s', UA1), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(0.45*xs, 0.06*Hr, sprintf('U_{PZ} \\approx %.1f m/s', UPZ), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    arrow2d(xs + 0.04*Lsz, 0, xs + 0.18*Lsz, 0, 0.2*HL, cK, 2);
    text(xs + 0.11*Lsz, -0.06*Hr, sprintf('U_{SZ} \\approx %.1f m/s', USZ), 'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
    text(xs, yc + 0.20*Hr, {'secondary holes', sprintf('N = %d, d_h = %.2f mm', round(Hs.Ntot), Hs.dh*1e3)}, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', cR, 'FontWeight', 'bold');
    dim_h(0, xs, -yc - 0.10*Hr, sprintf('L_{PZ} = %.1f mm', Lpz), 0.2*HL);
    dim_h(xs, xd, -yc - 0.10*Hr, sprintf('L_{SZ} = %.1f mm', Lsz), 0.2*HL);
else
    arrow2d(xs + 0.08*Lsz, yann, xd - 0.05*Lsz, yann, 0.2*HL, cK, 2);
    arrow2d(xs + 0.08*Lsz, 0, xd - 0.05*Lsz, 0, 0.2*HL, cK, 2);
    text(0.5*(xs + xd), yc + 0.03*Hr, sprintf('U_A \\approx %.1f m/s', UA2), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(0.5*(xs + xd), 0.06*Hr, sprintf('U_{SZ} \\approx %.1f m/s', USZ), 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
    text(xs, yc + 0.20*Hr, {'secondary holes', sprintf('N = %d', round(Hs.Ntot))}, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', cR, 'FontWeight', 'bold');
    text(xd, yc + 0.20*Hr, {'dilution holes', sprintf('N = %d, d_h = %.2f mm', round(Hd.Ntot), Hd.dh*1e3)}, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'Color', cR, 'FontWeight', 'bold');
    dim_h(xs, xd, -yc - 0.10*Hr, sprintf('L_{SZ} = %.1f mm', Lsz), 0.2*HL);
    dim_h(xd, xL, -yc - 0.10*Hr, sprintf('L_{DZ} = %.1f mm', Ldz), 0.2*HL);
    dim_h(xL, x4, -yc - 0.10*Hr, sprintf('L_{tr} = %.1f mm', Ltr), 0.2*HL);
end
% heights, on the left edge of the window
dim_v(xa + 0.02*W, -yc, yc, sprintf('H_r = %.1f mm', Hr), 0.05*Hr);
dim_v(xa + 0.07*W, -yl, yl, sprintf('H_L = %.1f mm', HL), 0.05*Hr);
axis equal; xlim(xw); ylim([-yc - 0.26*Hr, yc + 0.42*Hr]);
xlabel('x from the dome [mm]'); ylabel('radial offset from the mean radius r_{m3.2} [mm]');
title(sprintf('%s   (N_{noz} = %d, \\alpha = H_L/H_r = %.3f)', nm, r.Nnoz, r.alpha));
box on;
savepng(fh, fn);
end

%% ---------------------------------------------------------------------
%%  Fig. 9.E7  main burner side view
%% ---------------------------------------------------------------------
