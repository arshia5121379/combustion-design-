function fig_swirlers(M)
r = M.res;
fh = newfig('Fig. 9.E5 - primary swirlers and atomizers (from design results)', 1100, 640);
hold on;
ro = r.ro32*1e3; ri = r.ri32*1e3; rm = r.rm32*1e3; HL = r.HL*1e3; rt = r.rt*1e3; rh = r.rh*1e3;
Pn = 2*pi*rm/r.Nnoz;                       % circumferential pitch of one nozzle
nsh = min(3, r.Nnoz);
xr = nsh*Pn;
plot([0 xr], [ro ro], 'k-', 'LineWidth', 2.4);
plot([0 xr], [ri ri], 'k-', 'LineWidth', 2.4);
plot([0 xr], [rm + HL/2, rm + HL/2], 'k-', 'LineWidth', 1.5);
plot([0 xr], [rm - HL/2, rm - HL/2], 'k-', 'LineWidth', 1.5);
tt = linspace(0, 2*pi, 121);
for k = 1:nsh
    cx = (k - 0.5)*Pn;
    fill(cx + rt*cos(tt), rm + rt*sin(tt), [0.90 0.93 0.97], 'EdgeColor', 'k', 'LineWidth', 1.4);
    for j = 1:r.Nvane                       % swirl vanes (actual vane count)
        a = 2*pi*(j - 1)/r.Nvane;
        plot(cx + [rh rt]*cos(a), rm + [rh rt]*sin(a), 'k-', 'LineWidth', 0.8);
    end
    fill(cx + rh*cos(tt), rm + rh*sin(tt), [1 1 1], 'EdgeColor', 'k', 'LineWidth', 1.4);
    text(cx, rm, {'airblast', 'atomizer'}, 'HorizontalAlignment', 'center', 'FontSize', 8);
end
text(-4, ro, 'outer casing', 'HorizontalAlignment', 'right');
text(-4, rm + HL/2, 'outer liner', 'HorizontalAlignment', 'right');
text(-4, rm - HL/2, 'inner liner', 'HorizontalAlignment', 'right');
text(-4, ri, 'inner casing', 'HorizontalAlignment', 'right');
dim_v(xr + 8, rm - HL/2, rm + HL/2, sprintf('H_L = %.2f mm', HL), 4);
dim_v(xr + 24, ri, ro, sprintf('H_r = %.2f mm', ro - ri), 4);
dim_h(0, Pn, ro + 8, sprintf('pitch = %.2f mm', Pn), 4);
text(0.5*xr, ri - 8, {sprintf('N_{noz} = %d swirlers around the annulus (%d shown, unrolled)', r.Nnoz, nsh), ...
    sprintf('r_t = %.2f mm,  r_h = %.2f mm,  \\alpha_{sw} = %.0f deg,  S = %.3f,  A_{sw} = %.1f mm^2 per nozzle', ...
    rt, rh, r.asw, r.Sp, r.Asw*1e6)}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
axis equal; xlim([-48 xr + 36]); ylim([ri - 30, ro + 18]);
xlabel('circumferential distance [mm]'); ylabel('radius [mm]');
title('Fig. 9.E5 - layout of primary air swirlers and atomizers (to scale)');
box on;
savepng(fh, 'fig_9_E5_swirlers');
end

%% ---------------------------------------------------------------------
%%  Fig. 9.33 / 9.34  secondary and dilution zone jets
%% ---------------------------------------------------------------------
