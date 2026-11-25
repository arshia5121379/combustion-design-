function fig_hole_layout(M)
C = consts();
r = M.res; Hs = M.holes_sec; Hd = M.holes_dil; cin = C.in;
fh = newfig('Fig. 9.E6 - secondary and dilution hole layout (from design results)', 1200, 520);
hold on;
Pn = 2*pi*r.rm32/cin/r.Nnoz;                 % circumferential pitch of one nozzle, inch
no = max(1, round(Hs.Nper/2));               % secondary holes per nozzle per wall
nd = max(1, round(Hd.Nper/2));               % dilution holes per nozzle per wall
xs_rel = r.Lpz/cin; xd_rel = (r.Lpz + r.Lsz)/cin; xL_rel = r.Lliner/cin;
sO = (1:no)*Pn/(no + 1);                     % outer-wall secondary holes
sI = sO + Pn/(2*(no + 1));                   % inner-wall holes, staggered
sD = (1:nd)*Pn/(nd + 1);                     % dilution holes
dxs = 0.25*(xd_rel - xs_rel)/4;              % axial stagger between the two secondary rows
[X1, Y1] = hole_circles(xs_rel, sO, Hs.dh/cin/2);
[X2, Y2] = hole_circles(xs_rel + dxs, sI, Hs.dh/cin/2);
[X3, Y3] = hole_circles(xd_rel, sD, Hd.dh/cin/2);
h1 = plot(X1, Y1, '-', 'Color', 'r', 'LineWidth', 1.3);
h2 = plot(X2, Y2, '-', 'Color', [0.1 0.2 0.8], 'LineWidth', 1.3);
h3 = plot(X3, Y3, '-', 'Color', [0 0.5 0], 'LineWidth', 1.3);
plot([0 0], [0 Pn], 'k-', 'LineWidth', 2);
plot([xs_rel xs_rel], [0 Pn], '--', 'Color', [0.5 0.5 0.5]);
plot([xd_rel xd_rel], [0 Pn], '--', 'Color', [0.5 0.5 0.5]);
plot([xL_rel xL_rel], [0 Pn], 'k-', 'LineWidth', 1.5);
plot([0 xL_rel], [0 0], 'k-'); plot([0 xL_rel], [Pn Pn], 'k-');
zone_bracket(0, xs_rel, Pn + 0.35, 'L_{PZ}');
zone_bracket(xs_rel, xd_rel, Pn + 0.35, 'L_{SZ}');
zone_bracket(xd_rel, xL_rel, Pn + 0.35, 'L_{DZ}');
legend([h1 h2 h3], {sprintf('secondary, outer wall (d_h = %.2f mm)', Hs.dh*1e3), ...
    sprintf('secondary, inner wall (staggered)'), sprintf('dilution (d_h = %.2f mm)', Hd.dh*1e3)}, ...
    'Location', 'southoutside', 'Orientation', 'horizontal');
axis equal; xlim([-0.3, xL_rel + 0.3]); ylim([-0.3, Pn + 1.3]);
xlabel('x from dome [in]'); ylabel('circumferential pitch of one nozzle [in]');
title(sprintf('Fig. 9.E6 - holes per nozzle: secondary %d, dilution %d (circles to scale, liner unrolled)', 2*no, 2*nd));
box on;
savepng(fh, 'fig_9_E6_hole_layout');
end

%% ---------------------------------------------------------------------
%%  Fig. 9.27  afterburner combined diffuser with the mass flows
%% ---------------------------------------------------------------------
