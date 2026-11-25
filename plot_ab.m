function plot_ab(A)
r = A.res;
C = consts();
%% Figure 4: afterburner diffuser, shear layer and losses
fh = newfig('Afterburner: diffuser, mixing and losses', 1100, 780);
subax(2, 2, 1);
xs = [0, r.Lmixer + r.Lm, r.Lmixer + r.Lm + r.Ld]*1e3;
plot(xs, [r.ro1 r.ro1 r.ro1]*1e3, 'k-', 'LineWidth', 2); hold on;
plot(xs, [r.ri1 r.rim 0]*1e3, 'b-', 'LineWidth', 2);
xlabel('x from station 6A [mm]'); ylabel('radius [mm]');
legend('outer wall', 'inner wall (centre body)', 'Location', 'best');
title('Diffuser 6A -> 6.1 (Sec. 9.4.2.2)'); grid on;
subax(2, 2, 2);
ar = linspace(1.05, 2.6, 80);
etaa = (r.etaM*r.AR^2*(1 - 1./ar.^2) + 2*(r.AR./ar - 1))/(r.AR^2 - 1);
plot(ar, etaa, 'k-', 'LineWidth', 1.5); hold on;
plot(r.Am/r.A6A, r.etaC, 'ro', 'MarkerFaceColor', 'r');
xlabel('A_m / A_1'); ylabel('Combined diffusion efficiency \eta_D');
title('Diffusion efficiency (Eq. 9.128)'); grid on;
subax(2, 2, 3);
rr = linspace(0.5, 0.995, 80);
Gm = zeros(size(rr));
for i = 1:numel(rr)
    Gm(i) = ab_growth(rr(i), r.sd);
end
plot(rr, r.Cdelta*Gm, 'k-', 'LineWidth', 1.5); hold on;
plot(r.rv, r.Cdelta*ab_growth(r.rv, r.sd), 'ro', 'MarkerFaceColor', 'r');
xlabel('velocity ratio r = U_{16}/U_6'); ylabel('d(\delta)/dx');
title('Shear-layer growth (Eq. 9.56, as printed)'); grid on;
subax(2, 2, 4);
bar([r.CD*r.B, r.dPq_wet]);
set(gca, 'XTickLabel', {'dry (dPt/q1)', 'wet (dPt/q1)'});
ylabel('loss coefficient'); grid on;
title('Afterburner loss coefficient (Eq. 9.85)');

savepng(fh, 'ab_fig4_diffuser_mixing_losses');

%% Figure 5: flameholders and blowout
fh = newfig('Afterburner: flameholders and blowout (Table 9.3)', 1100, 780);
subax(2, 2, 1);
wh = linspace(0.25, 0.5, 60);
Bw = 1.034*wh - 0.1;
CDw = wh.^2./(Bw.*(1 - wh).^2);
plot(wh, Bw, 'k-', wh, CDw, 'b--', wh, CDw.*Bw, 'r-.', 'LineWidth', 1.3); hold on;
plot(r.WH, r.B, 'ko', r.WH, r.CD, 'bs', r.WH, r.dry, 'r^');
xlabel('W/H'); legend('B = D/H', 'C_D', 'dry loss', 'Location', 'best');
title('Vee-gutter parameters (Eqs. 9.84, 9.137)'); grid on;
subax(2, 2, 2);
Hw = (r.U61*r.tBO)./(4*wh.*(1 - wh));
plot(wh, Hw*1e3, 'k-', 'LineWidth', 1.5); hold on;
plot(r.WH, r.Hmin*1e3, 'ro', 'MarkerFaceColor', 'r');
xlabel('W/H'); ylabel('H_{min} [mm]');
title('Minimum channel height (Eq. 9.134)'); grid on;
subax(2, 2, 3);
semilogx(A.sweep.tau, A.sweep.eps, 'b-o', 'LineWidth', 1.2); hold on;
if ~isnan(r.tBO)
    plot([r.tBO r.tBO], [0 1], 'r--');
end
plot([r.ts r.ts], [0 1], 'k:');
xlabel('Residence time \tau [s]'); ylabel('Fuel conversion \epsilon');
legend('WSR steady state', 't_{BO}', 't_s (flameholder)', 'Location', 'best');
title('Afterburner WSR states (Table 9.3)'); grid on;
subax(2, 2, 4);
axis off;
txt = {sprintf('U1 = %.2f m/s, t_BO = %.3e s', r.U61, r.tBO), ...
       sprintf('H_{min} = %.3f mm, channel H = %.3f mm', r.Hmin*1e3, r.Hch*1e3), ...
       sprintf('t_s/t_BO = %.2f', r.ts/r.tBO), ...
       sprintf('flame spread length = %.2f mm', r.Lsp*1e3), ...
       sprintf('Station 7: M = %.4f, Pt7 wet = %.3f psi', r.M7, r.Pt7_wet/C.psi)};
text(0.02, 0.9, txt, 'FontSize', 11, 'VerticalAlignment', 'top');
title('Summary');
savepng(fh, 'ab_fig5_flameholders_blowout');
end


