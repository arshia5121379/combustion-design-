function fig_ab_nomix(A)
r = A.res; G = A.geo; N = A.nomix;
fh = newfig('Alternate no-mix afterburner (Sec. 9.4.2.6) - side view', 1300, 560);
hold on;
cK = [0.10 0.10 0.10];
plot(G.outer(:,1), G.outer(:,2), '-', 'Color', cK, 'LineWidth', 2.4);
plot(G.inner(:,1), G.inner(:,2), '-', 'Color', cK, 'LineWidth', 2);
plot(G.nm_slip(:,1), G.nm_slip(:,2), '--', 'Color', [0.1 0.4 0.8], 'LineWidth', 1.8);
plot(G.nm_gutters(:,1), G.nm_gutters(:,2), '-', 'Color', [0.8 0.1 0.1], 'LineWidth', 2);
xm = (r.Lmixer + r.Lm)*1e3;
plot([xm xm], [0, r.ro1*1e3], ':', 'Color', [0.45 0.45 0.45]);
text(xm, r.ro1*1e3 + 12, 'flameholders at station m', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
text(xm - 20, N.rslip*1e3, sprintf('slip surface r = %.1f mm', N.rslip*1e3), 'HorizontalAlignment', 'right', 'Color', [0.1 0.4 0.8]);
text(xm + 20, r.rim*1e3 + 0.5*N.Hs(1)*1e3, sprintf('core: H = %.1f mm, D = %.2f mm, %d ring(s)', N.Hs(1)*1e3, N.D(1)*1e3, N.Nv(1)), 'Color', [0.8 0.1 0.1]);
text(xm + 20, N.rslip*1e3 + 0.5*N.Hs(2)*1e3, sprintf('fan: H = %.1f mm, D = %.2f mm, %d ring(s)', N.Hs(2)*1e3, N.D(2)*1e3, N.Nv(2)), 'Color', [0.8 0.1 0.1]);
axis equal; grid on; box on;
ylim([0, r.ro1*1e3 + 60]);
xlabel('x [mm]  (x = 0 at station 6A)'); ylabel('r [mm]');
title(sprintf('No-mix afterburner: alpha = %.3f, fuel %.3f kg/s (%+.1f %% vs mixed)', N.alpha, N.mf_tot, 100*N.mf_incr));
savepng(fh, 'ab_fig_nomix');
end
