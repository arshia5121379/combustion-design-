function fig_main_side(M)
C = consts();
r = M.res; G = M.geo; Hs = M.holes_sec; Hd = M.holes_dil;
cin = C.in;
g = @(v) v/25.4;                                  % mm -> inch (G is stored in mm)
fh = newfig('Fig. 9.E7 - main burner side view (from design results)', 1300, 560);
hold on;
k = [0.10 0.10 0.10];
xL = (r.dx + r.Lliner)/cin;
% flame tube shading
fill(g([G.liner_o(1,1) G.liner_o(2,1) G.liner_i(2,1) G.liner_i(1,1)]), ...
     g([G.liner_o(1,2) G.liner_o(2,2) G.liner_i(2,2) G.liner_i(1,2)]), [1.00 0.93 0.85], 'EdgeColor', 'none');
plot(g(G.outer(:,1)), g(G.outer(:,2)), '-', 'Color', k, 'LineWidth', 2.4);
plot(g(G.inner(:,1)), g(G.inner(:,2)), '-', 'Color', k, 'LineWidth', 2.4);
plot(g(G.liner_o(:,1)), g(G.liner_o(:,2)), '-', 'Color', k, 'LineWidth', 1.6);
plot(g(G.liner_i(:,1)), g(G.liner_i(:,2)), '-', 'Color', k, 'LineWidth', 1.6);
plot(g(G.trans_o(:,1)), g(G.trans_o(:,2)), '-', 'Color', k, 'LineWidth', 1.6);
plot(g(G.trans_i(:,1)), g(G.trans_i(:,2)), '-', 'Color', k, 'LineWidth', 1.6);
plot(g(G.dome(:,1)), g(G.dome(:,2)), '-', 'Color', k, 'LineWidth', 1.6);
plot(g(G.splitter(:,1)), g(G.splitter(:,2)), '-', 'Color', [0.4 0.4 0.4], 'LineWidth', 1);
x0 = r.dx/cin; yc = r.rm32/cin; rti = r.rt/cin;
fill([x0 - rti, x0 + rti, x0 + rti, x0 - rti], [yc - rti, yc - rti, yc + rti, yc + rti], [0.85 0.88 0.95], ...
    'EdgeColor', k, 'LineWidth', 1.4);
text(g(G.splitter(1,1)) + 0.3, g(G.splitter(1,2)) + 0.45, 'splitter', 'FontSize', 9);
xs = (r.dx + r.Lpz)/cin;
xd = (r.dx + r.Lpz + r.Lsz)/cin;
ys_o = r.rLo/cin; ys_i = r.rLi/cin;
plot(xs, ys_o, 'rv', 'MarkerFaceColor', 'r'); plot(xs, ys_i, 'r^', 'MarkerFaceColor', 'r');
plot(xd, ys_o, 'gv', 'MarkerFaceColor', [0 0.6 0]); plot(xd, ys_i, '^', 'Color', [0 0.6 0], 'MarkerFaceColor', [0 0.6 0]);
ymax = max(g(G.outer(:,2))); ymin = min(g(G.inner(:,2)));
% hole labels go below the casing, joined to the holes by thin leader lines
plot([xs xs], [ymin - 0.5, ys_i], ':', 'Color', [0.5 0.5 0.5]);
plot([xd xd], [ymin - 0.5, ys_i], ':', 'Color', [0.5 0.5 0.5]);
text(xs, ymin - 0.6, {'secondary holes', sprintf('N = %d', round(Hs.Ntot)), sprintf('d_h = %.2f mm', Hs.dh*1e3)}, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Color', 'r', 'FontSize', 9);
text(xd, ymin - 0.6, {'dilution holes', sprintf('N = %d', round(Hd.Ntot)), sprintf('d_h = %.2f mm', Hd.dh*1e3)}, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Color', [0 0.5 0], 'FontSize', 9);
text(x0 - rti - 0.2, yc, {'airblast atomizer', '+ primary swirler'}, 'HorizontalAlignment', 'right', 'FontSize', 9);
% station tags
stx = g(G.station_pts(:,1)); stn = {'3.1', '3.2', '3.9', '4'};
for i = 1:numel(stx)
    plot([stx(i) stx(i)], [ymin - 0.25, ymin - 0.05], 'k-');
    text(stx(i), ymin - 3.6, ['stn ' stn{i}], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontSize', 8);
end
ytop = ymax + 1.0;
zone_bracket(x0, xs, ytop, 'L_{PZ}');
zone_bracket(xs, xd, ytop, 'L_{SZ}');
zone_bracket(xd, xL, ytop, 'L_{DZ}');
axis equal; xlim([-1.2, g(G.x_end) + 1.2]); ylim([ymin - 6.2, ytop + 1.6]);
grid on; box on;
xlabel('x [in]  (x = 0 at station 3.1)'); ylabel('r [in]');
title(sprintf('Fig. 9.E7 - main burner side view:  N_{noz} = %d,  H_L = %.3f in,  L_{liner} = %.2f in', ...
    r.Nnoz, r.HL/cin, r.Lliner/cin));
savepng(fh, 'fig_9_E7_main_burner_side');
end

%% ---------------------------------------------------------------------
%%  Fig. 9.E6  hole layout for one nozzle pitch
%% ---------------------------------------------------------------------
