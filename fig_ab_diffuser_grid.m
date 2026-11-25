function fig_ab_diffuser_grid(A)
GD = A.grid; r = A.res;
fh = newfig('Afterburner diffuser grid search (2theta = 9 deg)', 1100, 520);
subax(1, 2, 1);
contourf(GD.ARv, GD.Lrv, GD.eta, 20); colorbar; hold on;
plot(GD.AR_g, GD.Lr_g, 'rp', 'MarkerFaceColor', 'r', 'MarkerSize', 10);
if GD.valid
    plot(GD.ARd, GD.Lr_best, 'ko', 'MarkerFaceColor', 'w', 'MarkerSize', 8);
end
xlabel('area ratio AR'); ylabel('length ratio L/H_1');
title('\eta_D (Eq. 9.102): red = global best, circle = design AR');
subax(1, 2, 2);
plot(GD.Lr_curve, GD.eta_curve, 'k-', 'LineWidth', 1.5); hold on;
if GD.valid
    plot(GD.Lr_best, GD.eta_best, 'ro', 'MarkerFaceColor', 'r');
    plot(GD.Lr_an, GD.eta_an, 'bx', 'MarkerSize', 10, 'LineWidth', 1.5);
end
plot(r.Lm*r.rmm/(r.rm1*r.Hm*0 + r.rm1*(r.ro1 - r.ri1)), r.etaC, 'g+', 'MarkerSize', 10, 'LineWidth', 1.5);
grid on;
xlabel('length ratio L/H_1'); ylabel('\eta_D');
title(sprintf('design AR = %.3f: grid best (o), Eq. 9.103 (x), used (+)', GD.ARd));
savepng(fh, 'ab_fig_diffuser_grid');
end

%% ======================================================================
%%  ALTERNATE "NO-MIX" AFTERBURNER  (Sec. 9.4.2.6)
%% ======================================================================
