function fig_ab_full(A)
r = A.res; G = A.geo;
fh = newfig('Afterburner geometry (side view, from design results)', 1400, 560);
hold on;
cK = [0.10 0.10 0.10];
hub = [G.core_inner(1,1), 0; G.core_inner(1,:); G.inner(1:3,:); G.inner(4,:)];
fill(hub(:,1), hub(:,2), [0.82 0.82 0.82], 'EdgeColor', cK, 'LineWidth', 2);
plot(G.outer(:,1), G.outer(:,2), '-', 'Color', cK, 'LineWidth', 2.4);
plot(G.inner(4:5,1), G.inner(4:5,2), '-.', 'Color', [0.5 0.5 0.5]);
plot(G.bypass_split(:,1), G.bypass_split(:,2), ':', 'Color', cK, 'LineWidth', 1.5);
h1 = plot(G.gutters(:,1), G.gutters(:,2), '-', 'Color', [0.8 0.1 0.1], 'LineWidth', 2);
h2 = plot(G.flame(:,1), G.flame(:,2), '--', 'Color', [0.9 0.5 0.1]);
h3 = plot(G.spray(:,1), G.spray(:,2), 'o', 'Color', [0.7 0 0.7], 'MarkerFaceColor', [0.7 0 0.7], 'MarkerSize', 5);
xs = [0, (r.Lmixer + r.Lm)*1e3, r.x6*1e3];
nm = {'6A', 'm', '6.1'};
for i = 1:3
    plot([xs(i) xs(i)], [0, r.ro1*1e3], ':', 'Color', [0.45 0.45 0.45]);
    text(xs(i), r.ro1*1e3 + 15, ['stn ' nm{i}], 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', 9);
end
legend([h1 h2 h3], {'vee-gutters', 'flame spread', 'fuel spray bars'}, 'Location', 'southoutside', 'Orientation', 'horizontal');
axis equal; grid on; box on;
ylim([0, r.ro1*1e3 + 110]);
xlabel('x [mm]  (x = 0 at station 6A)'); ylabel('r [mm]');
title(sprintf('Afterburner: %d vee-gutter rings, flame zone %.1f mm, total length %.0f mm', r.Nr, r.Lsp*1e3, r.Ltotal*1e3));
savepng(fh, 'ab_full_side_view');
end


