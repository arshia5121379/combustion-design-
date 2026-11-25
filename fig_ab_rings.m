function fig_ab_rings(A)
r = A.res;
fh = newfig('Fig. 9.E12 - vee-gutter rings, end view at station 6.1', 800, 800);
hold on;
ro = r.ro1*1e3; ri2 = r.ri2*1e3; Dg = r.Dg*1e3; Hch = r.Hch*1e3;
rk = ri2 + ((1:r.Nr) - 0.5)*Hch;
t = linspace(0, 2*pi, 241);
fill(ro*cos(t), ro*sin(t), [0.96 0.96 0.96], 'EdgeColor', 'k', 'LineWidth', 2);
if ri2 > 1
    fill(ri2*cos(t), ri2*sin(t), [0.82 0.82 0.82], 'EdgeColor', 'k', 'LineWidth', 2);
end
for k = 0:r.Nr                                   % channel boundaries
    rb = ri2 + k*Hch;
    if rb > 1 && k < r.Nr
        plot(rb*cos(t), rb*sin(t), '--', 'Color', [0.55 0.55 0.55]);
    end
end
for k = 1:r.Nr
    ra = rk(k) + 0.5*Dg; rb = rk(k) - 0.5*Dg;
    fill([ra*cos(t), rb*cos(t(end:-1:1))], [ra*sin(t), rb*sin(t(end:-1:1))], [0.80 0.10 0.10], 'EdgeColor', 'none');
    text(rk(k)*cosd(35), rk(k)*sind(35), sprintf('ring %d', k), 'FontSize', 8, 'Color', 'w', ...
        'HorizontalAlignment', 'center', 'FontWeight', 'bold');
end
text(0, -ro*1.06, {sprintf('%d vee-gutter rings,  W/H = %.2f,  B = D/H = %.3f', r.Nr, r.WH, r.B), ...
    sprintf('gutter width D = %.2f mm,  channel height H = %.2f mm', Dg, Hch), ...
    sprintf('ring radii r = %s mm', strtrim(sprintf('%.1f  ', rk))), ...
    'radial spokes are not sized by this code'}, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
title('Fig. 9.E12 - vee-gutter ring layout, looking downstream (to scale)');
axis equal; axis off; xlim([-1.1*ro, 1.1*ro]); ylim([-1.45*ro, 1.1*ro]);
savepng(fh, 'fig_9_E12_vee_gutter_rings');
end

%% ---------------------------------------------------------------------
%%  complete afterburner side view
%% ---------------------------------------------------------------------
