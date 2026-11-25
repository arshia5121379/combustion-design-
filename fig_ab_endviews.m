function fig_ab_endviews(A)
r = A.res; I = A.in; C = consts();
fh = newfig('Fig. 9.36 - afterburner diffuser cross-sections (from design results)', 1300, 520);
hold on;
set(gca, 'FontSize', 9);
ro = r.ro1*1e3; rin = [r.ri1, r.rim, r.ri2]*1e3;
nm = {'Station 6A  (1)', 'Section m', 'Station 6.1  (2)'};
ar = [I.A6A, r.Am, I.A61];
Hh = [r.ro1 - r.ri1, r.Hm, r.H2]*1e3;
t = linspace(0, 2*pi, 181);
sp_x = 2.6*ro;
for k = 1:3
    cx = (k - 1)*sp_x;
    xo = cx + ro*cos(t); yo = ro*sin(t);
    xi = cx + rin(k)*cos(t(end:-1:1)); yi = rin(k)*sin(t(end:-1:1));
    fill([xo xi], [yo yi], [0.70 0.80 0.95], 'EdgeColor', 'none');
    plot(xo, yo, 'k-', 'LineWidth', 2);
    if rin(k) > 1
        plot(cx + rin(k)*cos(t), rin(k)*sin(t), 'k-', 'LineWidth', 2);
    end
    plot(cx, 0, 'k+');
    text(cx, -ro - 0.06*ro, {nm{k}, sprintf('A = %.4f m^2  (%.3f ft^2)', ar(k), ar(k)/C.ft2), ...
        sprintf('r_o = %.1f mm,  r_i = %.1f mm', ro, rin(k)), sprintf('H = %.1f mm', Hh(k))}, ...
        'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'FontWeight', 'bold');
end
for k = 1:2
    xa = (k - 1)*sp_x + ro + 0.12*ro; xb = k*sp_x - ro - 0.12*ro;
    arrow2d(xa, 0, xb, 0, 0.1*ro, [0.1 0.1 0.1], 2);
    if k == 1
        l2 = sprintf('L_m = %.1f mm', r.Lm*1e3);
    else
        l2 = sprintf('L_d = %.1f mm', r.Ld*1e3);
    end
    text(0.5*(xa + xb), 0.05*ro, l2, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end
text(0.5*(ro + 0.12*ro + sp_x - ro - 0.12*ro), -0.05*ro, sprintf('m_{6A} = %.2f kg/s', I.mdot6A), ...
    'HorizontalAlignment', 'center', 'VerticalAlignment', 'top', 'Color', [0.05 0.3 0.7], 'FontWeight', 'bold');
title('Fig. 9.36 - diffuser cross-sections 6A -> m -> 6.1, looking downstream (to scale)');
axis equal; axis off; xlim([-1.2*ro, 2*sp_x + 1.2*ro]); ylim([-2.1*ro, 1.2*ro]);
savepng(fh, 'fig_9_36_ab_diffuser_sections');
end

%% ---------------------------------------------------------------------
%%  Fig. 9.E12  vee-gutter rings (end view at station 6.1)
%% ---------------------------------------------------------------------
