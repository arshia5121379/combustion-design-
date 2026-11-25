function fig_ab_diffuser(A)
C = consts(); r = A.res; G = A.geo; I = A.in;
fh = newfig('Fig. 9.27 - combined diffuser 6A -> 6.1 (from design results)', 1400, 640);
hold on;
set(gca, 'Position', [0.02 0.03 0.96 0.90], 'FontSize', 9);
cK = [0.10 0.10 0.10]; cB = [0.05 0.30 0.70]; cR = [0.80 0.10 0.10];
ro = r.ro1*1e3; ri1 = r.ri1*1e3; rim = r.rim*1e3; ri6 = I.ri6*1e3; rsp = r.rsplit*1e3; ri2 = r.ri2*1e3;
Lmx = r.Lmixer*1e3; xm = (r.Lmixer + r.Lm)*1e3; x6 = r.x6*1e3; xu = -r.Lduct*1e3; xend = r.xend*1e3;
% hub (centre body), outer wall, splitter and axis
fill([xu xu 0 Lmx xm xm], [0 ri6 ri1 ri1 rim 0], [0.82 0.82 0.82], 'EdgeColor', cK, 'LineWidth', 2);
plot([xu xend], [ro ro], '-', 'Color', cK, 'LineWidth', 2.4);
plot([xu 0], [rsp rsp], ':', 'Color', cK, 'LineWidth', 1.5);
plot([xu x6], [0 0], '-.', 'Color', [0.5 0.5 0.5]);
plot(G.gutters(:,1), G.gutters(:,2), '-', 'Color', cR, 'LineWidth', 2);
% station lines
xst = [0, xm, x6];
for i = 1:3
    plot([xst(i) xst(i)], [-135, ro + 55], ':', 'Color', [0.45 0.45 0.45]);
end
% area / height labels at the stations
lab = {{'Station 6A  (1)', sprintf('A_1 = %.4f m^2  (%.3f ft^2)', I.A6A, I.A6A/C.ft2), sprintf('H_1 = %.1f mm', ro - ri1)}, ...
       {'Section m', sprintf('A_m = %.4f m^2  (%.3f ft^2)', r.Am, r.Am/C.ft2), sprintf('H_m = %.1f mm', r.Hm*1e3)}, ...
       {'Station 6.1  (2)', sprintf('A_2 = %.4f m^2  (%.3f ft^2)', I.A61, I.A61/C.ft2), sprintf('H_2 = %.1f mm', r.H2*1e3)}};
for i = 1:3
    text(xst(i), ro + 62, lab{i}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold');
end
dim_v(35, ri1, ro, '', 20);
dim_v(xm + 25, rim, ro, '', 20);
dim_v(x6 - 25, ri2, ro, '', 20);
% length dimensions below the axis
dim_h(Lmx, xm, -60, sprintf('L_m = %.1f mm  (%.2f in)', r.Lm*1e3, r.Lm/C.in), 22);
dim_h(xm, x6, -60, sprintf('L_d = %.1f mm', r.Ld*1e3), 22);
if Lmx > 0
    dim_h(0, Lmx, -60, sprintf('mixer %.0f mm', Lmx), 22);
end
dim_h(Lmx, x6, -115, sprintf('L = L_m + L_d = %.1f mm', (r.Lm + r.Ld)*1e3), 22);
% mass flows
ycore = 0.5*(ri6 + rsp); ybyp = 0.5*(rsp + ro);
arrow2d(xu + 20, ycore, xu + 230, ycore, 24, cB, 2.5);
arrow2d(xu + 20, ybyp, xu + 230, ybyp, 24, cB, 1.5);
text(xu - 20, ycore, sprintf('m_6 (core) = %.2f kg/s  (%.2f lbm/s)', I.mdot6, I.mdot6/C.lbm), ...
    'HorizontalAlignment', 'right', 'Color', cB, 'FontWeight', 'bold');
text(xu - 20, ybyp, sprintf('m_{16} (bypass) = %.2f kg/s  (%.2f lbm/s)', I.mdot16, I.mdot16/C.lbm), ...
    'HorizontalAlignment', 'right', 'Color', cB, 'FontWeight', 'bold');
arrow2d(350, 320, 850, 320, 30, cK, 4);
text(600, 305, {sprintf('m_{6A} = m_6 + m_{16} = %.2f kg/s', I.mdot6A), sprintf('(%.2f lbm/s)', I.mdot6A/C.lbm)}, ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontWeight', 'bold');
arrow2d(x6 + 80, 266, xend - 40, 266, 30, cR, 4);
text(x6 + 100, 276, {sprintf('m_7 = m_{6A} + m_{f,AB} = %.2f kg/s', I.mdot7), sprintf('(%.2f lbm/s)', I.mdot7/C.lbm), ...
    sprintf('m_{f,AB} = %.3f kg/s  (%.3f lbm/s)', I.mfAB, I.mfAB/C.lbm)}, ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom', 'FontWeight', 'bold', 'Color', cR);
% flow table
tb = cell(6, 1);
tb{1} = sprintf('%-16s %9s %9s', 'stream', 'kg/s', 'lbm/s');
nmv = {'m6 (core)', 'm16 (bypass)', 'm6A = m6+m16', 'mf,AB (fuel)', 'm7 = m6A+mf,AB'};
val = [I.mdot6, I.mdot16, I.mdot6A, I.mfAB, I.mdot7];
for i = 1:5
    tb{i + 1} = sprintf('%-16s %9.3f %9.3f', nmv{i}, val(i), val(i)/C.lbm);
end
text(-800, -40, tb, 'FontName', 'Courier', 'FontSize', 9, 'Interpreter', 'none', ...
    'HorizontalAlignment', 'left', 'VerticalAlignment', 'top');
title(sprintf('Fig. 9.27 - afterburner combined diffuser (flat-wall + dump):  AR = %.3f,  \\eta_{Dm} = %.2f,  \\eta_D = %.3f,  half-angle 4.5 deg (9 deg included)', ...
    r.AR, r.etaM, r.etaC));
axis equal; xlim([-800 x6 + 650]); ylim([-270, ro + 200]); axis off;
savepng(fh, 'fig_9_27_ab_diffuser');
end

%% ---------------------------------------------------------------------
%%  Fig. 9.36  diffuser cross-sections (end view)
%% ---------------------------------------------------------------------
