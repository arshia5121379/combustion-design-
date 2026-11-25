function plot_main(M)
r = M.res;
C = consts();
%% Figure 1: air partition, liner cooling and liner height
fh = newfig('Main burner: air partition and liner design', 1100, 780);
subax(2, 2, 1);
bar([r.mu_pz r.mu_sz r.mu_c r.mu_dz]);
set(gca, 'XTickLabel', {'Primary', 'Secondary', 'Cooling', 'Dilution'});
ylabel('Air mass fraction'); grid on;
title('Air partition (Table 9.E4)');
subax(2, 2, 2);
TgR = 3000:100:4000;
TgK = TgR*C.degR;
mpz = zeros(size(TgK));
msz = mpz;
mcv = mpz;
mdz = mpz;
for i = 1:numel(TgK)
    phz = (TgK(i) - M.in.Tt31)/(r.eps_pz*r.dTmax);      % Eq. (9.92)
    phs = (TgK(i) - M.in.Tt31)/r.dTmax;                 % Eq. (9.97)
    mpz(i) = r.phi4/phz;
    msz(i) = r.phi4/phs - mpz(i);
    ec = (TgK(i) - r.Tm)/(TgK(i) - r.Tc);
    mcv(i) = cool_fraction(ec, r.coolType);
    mdz(i) = 1 - mpz(i) - msz(i) - mcv(i);
end
plot(TgR, mcv, 'b-o', TgR, msz, 'k-^', TgR, mdz, 'g-s', 'LineWidth', 1.2); hold on;
plot(r.Tg/C.degR, r.mu_c, 'bp', 'MarkerSize', 12, 'MarkerFaceColor', 'b');
xlabel('Design gas temperature Tg [R]'); ylabel('Air mass fraction');
legend('cooling', 'secondary', 'dilution', 'design point', 'Location', 'best');
title('Air fractions vs Tg (cf. Fig. 9.E3)'); grid on;
subax(2, 2, 3);
mu = linspace(0.05, 0.6, 100);
al = 1 - mu.^(2/3)/r.dPq^(1/3);
plot(mu, al, 'k-', 'LineWidth', 1.5); hold on;
plot(r.muA, r.alpha, 'ro', 'MarkerFaceColor', 'r');
xlabel('mu_A = mu_{sz} + mu_{dz}'); ylabel('alpha_{opt} = H_L/H_r');
title('Optimum liner-to-reference height (Eq. 9.109)'); grid on;
subax(2, 2, 4);
eta = linspace(0.6, 1.0, 60);
plot(eta, r.Cpid*(1 - eta), 'b-', 'LineWidth', 1.5); hold on;
plot(r.etaD, r.Cpid*(1 - r.etaD), 'ro', 'MarkerFaceColor', 'r');
dPr = (M.in.Pt31 - M.in.Pt32)/(M.in.Pt31 - M.in.P31);
plot([0.6 1.0], [dPr dPr], 'k--');
xlabel('Diffuser efficiency \eta_D'); ylabel('(\DeltaP_t/q_1) diffuser');
legend('Eq. (9.66)', 'design', 'allocated', 'Location', 'best');
title('Diffuser loss vs efficiency'); grid on;

savepng(fh, 'main_fig1_air_partition_and_liner');

%% Figure 2: jets, swirlers, holes and stirring
fh = newfig('Main burner: jets, swirlers, holes and stirring', 1100, 780);
subax(2, 2, 1);
qj = r.dPq;
qAv = linspace(0.02, qj*0.99, 100);
YdJ = 1.15*sqrt(qj/M.holes_sec.qL)*sqrt(1 - qAv/qj);
plot(qAv, YdJ, 'k-', 'LineWidth', 1.5); hold on;
plot(M.holes_sec.qA, M.holes_sec.YdJ, 'rs', 'MarkerFaceColor', 'r', 'MarkerSize', 8);
plot(M.holes_dil.qA, M.holes_dil.YdJ, 'g^', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
xlabel('Annulus ratio q_A/q_r'); ylabel('Y_{max}/d_j');
legend('Eq. (9.107)', 'secondary', 'dilution', 'Location', 'best');
title('Jet penetration (secondary and dilution)'); grid on;
subax(2, 2, 2);
ang = linspace(20, 65, 100);
Sg = (2/3)*tan(ang*C.deg).*(1 - (r.rh/r.rt)^3)./(1 - (r.rh/r.rt)^2);
plot(ang, Sg, 'k-', 'LineWidth', 1.5); hold on;
plot([20 65], [0.6 0.6], 'r--');
plot([20 65], [1.0 1.0], 'r--');
plot(r.asw, r.Sp, 'bo', 'MarkerFaceColor', 'b');
xlabel('Swirler angle \alpha_{sw} [deg]'); ylabel('Swirl number S');
title('Swirl number (Eq. 9.48), band 0.6-1.0'); grid on;
subax(2, 2, 3);
bar([M.holes_sec.dj M.holes_sec.dh M.holes_dil.dj M.holes_dil.dh]*1e3);
set(gca, 'XTickLabel', {'Sec d_j', 'Sec d_h', 'Dil d_j', 'Dil d_h'});
ylabel('Diameter [mm]'); grid on;
title('Jet diameters (vena contracta and hole)');
subax(2, 2, 4);
bar([r.dPq, r.dPq_min]);
set(gca, 'XTickLabel', {'allocated', 'stirring min.'});
ylabel('(\DeltaP_t/q_r)'); grid on;
title('Total pressure loss: allocated vs stirring minimum');

savepng(fh, 'main_fig2_jets_swirl_holes');

%% Figure 3: primary-zone WSR kinetics
if ~isempty(M.kin)
    fh = newfig('Main burner: primary-zone WSR kinetics (Eq. 9.19, Table 9.3)', 1100, 780);
    taus = logspace(-7, -3, 13);
    K = kin_mechanism();
    nF = kin_fresh_comp(K, r.phi_pz);
    nS = kin_hot_start(K, kin_burned_comp(K, r.phi_pz));
    S = kin_struct(K, nF, M.in.Tt32, M.in.Pt32, r.phi_pz, r.dTmax);
    [ev, Tv] = kin_sweep(S, nS, taus);
    subax(2, 2, 1);
    semilogx(taus, ev, 'b-o', 'LineWidth', 1.2); hold on;
    if ~isnan(M.kin.tBO)
        plot([M.kin.tBO M.kin.tBO], [0 1], 'r--');
    end
    plot([M.kin.tau M.kin.tau], [0 1], 'k:');
    xlabel('Residence time \tau [s]'); ylabel('Fuel conversion \epsilon');
    legend('WSR steady state', 't_{BO}', 'design \tau', 'Location', 'best');
    title('WSR stationary states (cf. Fig. 9.10)'); grid on;
    subax(2, 2, 2);
    semilogx(taus, Tv, 'r-o', 'LineWidth', 1.2); hold on;
    if ~isnan(M.kin.tBO)
        plot([M.kin.tBO M.kin.tBO], [min(Tv) max(Tv)], 'r--');
    end
    xlabel('Residence time \tau [s]'); ylabel('T [K]');
    title('Gas temperature (Eq. 9.23)'); grid on;
    subax(2, 2, 3);
    sel = {'O2', 'N2', 'H2O', 'CO2', 'CO', 'OH', 'H', 'O', 'NO', 'CH2O'};
    xv = zeros(numel(sel), 1);
    for i = 1:numel(sel)
        k = find(strcmp(K.sp, sel{i}), 1);
        if ~isempty(k)
            xv(i) = M.kin.x(k);
        end
    end
    bar(xv);
    set(gca, 'XTickLabel', sel, 'XTickLabelRotation', 45);
    ylabel('Mole fraction'); grid on;
    title('Design-point composition (WSR)');
    subax(2, 2, 4);
    axis off;
    txt = {sprintf('tau_design = %.3e s', M.kin.tau), ...
           sprintf('eps (WSR) = %.4f   (target %.2f)', M.kin.eps, r.eps_pz), ...
           sprintf('T (WSR) = %.0f K   (Tg design %.0f K)', M.kin.T, r.Tg), ...
           sprintf('t_BO = %.3e s   (book KINETX 4.4e-6 s)', M.kin.tBO), ...
           sprintf('tau / t_BO = %.2f', M.kin.tau/M.kin.tBO)};
    text(0.02, 0.9, txt, 'FontSize', 11, 'VerticalAlignment', 'top');
    title('Summary');
    savepng(fh, 'main_fig3_primary_zone_kinetics');
end
end

