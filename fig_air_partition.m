function fig_air_partition(M)
C = consts(); r = M.res; I = M.in;
m31 = I.mdot31; mf = I.mdotf; m4 = I.mdot4;
mPZ = r.mu_pz*m31; mSZ = r.mu_sz*m31; mDZ = r.mu_dz*m31; mC = r.mu_c*m31;
mA = mSZ + mDZ;
fh = newfig('Fig. 9.23 - air partitioning (from design results)', 1300, 720);
hold on;
set(gca, 'Position', [0.02 0.03 0.96 0.90], 'FontSize', 9);
cB = [0.05 0.30 0.70]; cR = [0.80 0.10 0.10]; cG = [0.00 0.50 0.25]; cK = [0.10 0.10 0.10];
lw = @(mu) 1.2 + 9*mu;
ym = 27; yt = 40; yb = 14; yc1 = 44.5; yc2 = 9.5;
x0 = 40; Ltot = 62; xsp = 10; gp = 1.6;
Lz = [r.Lpz r.Lsz r.Ldz];
xz = x0 + Ltot*[0 cumsum(Lz)]/sum(Lz);          % zone boundaries (to scale with Lpz, Lsz, Ldz)
xs = xz(2); xd = xz(3); xe = xz(4);

% casing, dome and liner walls (gaps = secondary / dilution holes)
plot([0 xsp + 2 xe + 8], [ym + 7 49 49], '-', 'Color', cK, 'LineWidth', 2.2);
plot([0 xsp + 2 xe + 8], [ym - 7 5 5], '-', 'Color', cK, 'LineWidth', 2.2);
t = linspace(pi/2, 3*pi/2, 60);
plot(x0 + 9*cos(t), ym + 13*sin(t), '-', 'Color', cK, 'LineWidth', 2.2);
for yy = [yt yb]
    plot([x0 xs - gp], [yy yy], '-', 'Color', cK, 'LineWidth', 2.2);
    plot([xs + gp xd - gp], [yy yy], '-', 'Color', cK, 'LineWidth', 2.2);
    plot([xd + gp xe], [yy yy], '-', 'Color', cK, 'LineWidth', 2.2);
end
plot([xs xs], [yb yt], '--', 'Color', [0.55 0.55 0.55]);
plot([xd xd], [yb yt], '--', 'Color', [0.55 0.55 0.55]);

% inlet and the three branches (line width is proportional to the flow fraction)
arrow2d(-6, ym, xsp, ym, 3, cK, 6);
arrow2d(xsp, ym, x0 - 6, ym, 2.6, cR, lw(r.mu_pz));                 % primary air
plot([xsp 17], [ym yc1], '-', 'Color', cB, 'LineWidth', lw(r.muA));  % annulus air
plot([17 xs], [yc1 yc1], '-', 'Color', cB, 'LineWidth', lw(r.muA));
plot([xs xd], [yc1 yc1], '-', 'Color', cB, 'LineWidth', lw(r.mu_dz));
arrow2d(xs, yc1, xs, yt - 7, 2.4, cB, lw(r.mu_sz));                  % secondary jets
arrow2d(xd, yc1, xd, yt - 7, 2.4, cB, lw(r.mu_dz));                  % dilution jets
plot([xsp 16], [ym yc2], '-', 'Color', cG, 'LineWidth', lw(r.mu_c)); % liner cooling air
plot([16 xe], [yc2 yc2], '-', 'Color', cG, 'LineWidth', lw(r.mu_c));
for xx = linspace(x0 + 4, xe - 4, 9)
    arrow2d(xx, yc2 + 1.5, xx + 3, yb + 1.2, 1.3, cG, 1.0);
end
% products inside the liner and exit
arrow2d(x0 + 4, ym - 5, xs - 4, ym - 5, 2.4, cK, 1.5);
arrow2d(xs + 4, ym - 5, xd - 4, ym - 5, 2.4, cK, 2.5);
arrow2d(xd + 4, ym - 5, xe - 2, ym - 5, 2.4, cK, 3.5);
arrow2d(xe + 1, ym, xe + 22, ym, 3, cK, 6);

% zone names
nm = {'Primary zone', 'Secondary zone', 'Dilution zone'};
for i = 1:3
    text(0.5*(xz(i) + xz(i + 1)), yt - 2.5, {nm{i}, sprintf('L = %.1f mm', Lz(i)*1e3)}, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 8.5, 'FontWeight', 'bold');
end

% mass flow labels
text(-11, ym + 4, {sprintf('m_{3.1} = %.2f kg/s', m31), sprintf('(%.2f lbm/s)', m31/C.lbm)}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
text(xsp + 2, ym + 1.3, sprintf('m_{PZ} = %.2f kg/s', mPZ), 'Color', cR, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
text(14, 51, {sprintf('m_A = %.2f kg/s', mA), sprintf('(%.2f lbm/s)', mA/C.lbm)}, 'Color', cB, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
text(xs, 51, {sprintf('m_{SZ} = %.2f kg/s', mSZ), sprintf('(%.2f lbm/s)', mSZ/C.lbm)}, 'Color', cB, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
text(xd, 51, {sprintf('m_{DZ} = %.2f kg/s', mDZ), sprintf('(%.2f lbm/s)', mDZ/C.lbm)}, 'Color', cB, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
text(0.5*(x0 + xe), 3.2, sprintf('m_C = %.2f kg/s  (%.2f lbm/s)  liner cooling air', mC, mC/C.lbm), 'Color', cG, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontWeight', 'bold');
text(xe + 2, ym - 3, {sprintf('m_4 = %.2f kg/s', m4), sprintf('(%.2f lbm/s)', m4/C.lbm), 'm_4 = m_{3.1} + m_f'}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', 'FontWeight', 'bold');

% table of all flows
rows = {'m3.1', m31, 1; 'mPZ', mPZ, r.mu_pz; 'mSZ', mSZ, r.mu_sz; 'mDZ', mDZ, r.mu_dz; ...
        'mC', mC, r.mu_c; 'mA = mSZ+mDZ', mA, r.muA; 'mf (fuel)', mf, mf/m31; 'm4 = m3.1+mf', m4, m4/m31};
tb = cell(size(rows, 1) + 1, 1);
tb{1} = sprintf('%-14s %9s %9s %9s', 'stream', 'kg/s', 'lbm/s', '% of m3.1');
for i = 1:size(rows, 1)
    tb{i + 1} = sprintf('%-14s %9.3f %9.3f %9.2f', rows{i, 1}, rows{i, 2}, rows{i, 2}/C.lbm, 100*rows{i, 3});
end
text(-11, -4, tb, 'FontName', 'Courier', 'FontSize', 9, 'Interpreter', 'none', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
text(48, -4, {sprintf('Mass balance: m_{PZ} + m_A + m_C = %.3f kg/s  (m_{3.1} = %.3f kg/s)', mPZ + mA + mC, m31), ...
    sprintf('Airblast air inside m_{PZ}: m_{sw} = %.2f kg/s (3 lbm air per lbm fuel)', r.mdot_sw), ...
    sprintf('Line width of each arrow is proportional to its share of m_{3.1}')}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
title(sprintf('Fig. 9.23 - air partitioning: \\phi_{pz} = %.2f, T_g = %.0f K, \\mu_{pz} = %.3f, \\mu_{sz} = %.3f, \\mu_c = %.3f, \\mu_{dz} = %.3f', ...
    r.phi_pz, r.Tg, r.mu_pz, r.mu_sz, r.mu_c, r.mu_dz));
axis equal; xlim([-12 144]); ylim([-27 58]); axis off;
savepng(fh, 'fig_9_23_air_partition');
end

%% ---------------------------------------------------------------------
%%  Fig. 9.E5  primary swirlers and atomizers
%% ---------------------------------------------------------------------
