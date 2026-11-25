function N = nomix_ab(I, K, S)
% core and fan streams co-flow through the diffuser separated by a slip surface;
% static pressure is equal in both streams, so Eq. (9.64) gives the same dP in each
q1c = I.Pt6 - S.P6;                                     % core dynamic pressure at entry
q1f = I.Pt16 - S.P16;                                   % fan dynamic pressure at entry
Am = S.Am;
if I.A6 + I.A16 >= Am
    error('Section-m area is not larger than A6 + A16: no-mix split impossible.');
end
fa = @(a) q1c*(1 - (I.A6/(a*Am))^2) - q1f*(1 - (I.A16/((1 - a)*Am))^2);
alpha = fzero(fa, [1.0001*I.A6/Am, 1 - 1.0001*I.A16/Am]);
Amc = alpha*Am;  Amf = (1 - alpha)*Am;
ARc = Amc/I.A6;  ARf = Amf/I.A16;
dPm = S.etaD*q1c*(1 - 1/ARc^2);                         % Eq. (9.64)
Pm = S.P6 + dPm;
rslip = sqrt(S.rim^2 + Amc/pi);                         % slip-surface radius, Eq. (9.122)
Hs = [rslip - S.rim, S.ro1 - rslip];                    % radial heights [core fan]
Um = [S.U6*I.A6/Amc, S.U16*I.A16/Amf];                  % continuity
Tin = [I.Tt6, I.Tt16];
% fuel needed per stream for Tt7 (linear Eq. (9.23), calibrated on the mixed design)
kcal = S.phiMix/((I.Tt7 - I.Tt6A)/S.dTmax);
phis = kcal*(I.Tt7 - Tin)/S.dTmax;
m4s = [S.m4, 0];  mairs = [I.mdot6 - S.m4, I.mdot16];
mf = zeros(1, 2); tBO = zeros(1, 2); phiF = zeros(1, 2);
for k = 1:2
    if phis(k) <= 0
        error('No-mix stream %d: Tt7 (%.0f K) is not above the stream inlet temperature (%.0f K).', k, I.Tt7, Tin(k));
    end
    mf(k) = fzero(@(x) nm_phi(K, S, m4s(k), mairs(k), x) - phis(k), [1e-6, 2*mairs(k) + 1]);
    [nin, nS, phiF(k)] = kin_ab_comp(K, S.phi4, m4s(k), mairs(k), mf(k), S.RR);
    kd = kin_design(K, nin, nS, Tin(k), Pm, phiF(k), S.dTmax, Hs(k)/Um(k), 0.5);
    tBO(k) = kd.tBO;
end
WH = S.WH;
B = 1.034*WH - 0.1;                                     % Eq. (9.137)
Ns = 4*WH*(1 - WH);
Hmin = Um.*tBO/Ns;                                      % Eq. (9.134)/(9.135)
Nmax = floor(Hs./(10*Hmin));                            % book rule, 10x margin
Nv = max(1, Nmax);
Hch = Hs./Nv;
D = B*Hch;
ts = 4*WH*Hch./(Um/(1 - WH));
Dspoke = B*10*Hmin(2);                                  % fan-stream spoke width for ts = 10 t_BO
N = struct('alpha', alpha, 'Amc', Amc, 'Amf', Amf, 'ARc', ARc, 'ARf', ARf, 'dPm', dPm, 'Pm', Pm, ...
    'rslip', rslip, 'Hs', Hs, 'Um', Um, 'phis', phis, 'phiF', phiF, 'mf', mf, 'mf_tot', sum(mf), ...
    'mf_incr', sum(mf)/S.mfMix - 1, 'tBO', tBO, 'Hmin', Hmin, 'Nmax', Nmax, 'Nv', Nv, 'Hch', Hch, ...
    'D', D, 'ts', ts, 'ts_ratio', ts./tBO, 'B', B, 'WH', WH, 'Dspoke', Dspoke, 'q1c', q1c, 'q1f', q1f);
C = consts();
fprintf('    NO-MIX: core area fraction alpha = %.4f, A_m,core = %.4f m^2, A_m,fan = %.4f m^2\n', alpha, Amc, Amf);
fprintf('            P_m = %.3f psi, slip radius = %.2f mm, heights core/fan = %.2f / %.2f mm\n', Pm/C.psi, rslip*1e3, Hs(1)*1e3, Hs(2)*1e3);
fprintf('            U_m core/fan = %.2f / %.2f m/s, t_BO core/fan = %.3e / %.3e s\n', Um(1), Um(2), tBO(1), tBO(2));
fprintf('            fuel core/fan = %.4f / %.4f kg/s, total = %.4f kg/s (%+.1f %% vs mixed %.4f kg/s)\n', mf(1), mf(2), sum(mf), 100*N.mf_incr, S.mfMix);
fprintf('            H_min core/fan = %.3f / %.3f mm, N_max = %d / %d, D = %.3f / %.3f mm, t_s/t_BO = %.2f / %.2f\n', ...
    Hmin(1)*1e3, Hmin(2)*1e3, Nmax(1), Nmax(2), D(1)*1e3, D(2)*1e3, N.ts_ratio(1), N.ts_ratio(2));
fprintf('            fan spoke width for t_s = 10 t_BO: D = %.3f mm\n', Dspoke*1e3);
rp = {};
rp = rl(rp, 'No-mix (Sec. 9.4.2.6): q1 core/fan = %.4f / %.4f psi, core area fraction alpha = %.4f, AR core/fan = %.4f / %.4f', q1c/C.psi, q1f/C.psi, alpha, ARc, ARf);
rp = rl(rp, 'No-mix: A_m core = %.4f m^2 (%.3f ft^2), A_m fan = %.4f m^2 (%.4f ft^2), P_m = %.3f psi, slip radius = %.2f mm', Amc, Amc/C.ft2, Amf, Amf/C.ft2, Pm/C.psi, rslip*1e3);
rp = rl(rp, 'No-mix: radial heights core/fan = %.2f / %.2f mm, U_m core/fan = %.2f / %.2f m/s', Hs(1)*1e3, Hs(2)*1e3, Um(1), Um(2));
rp = rl(rp, 'No-mix: phi core/fan = %.4f / %.4f, fuel core/fan = %.4f / %.4f kg/s, total = %.4f kg/s (%+.2f %% vs mixed design %.4f kg/s)', phiF(1), phiF(2), mf(1), mf(2), sum(mf), 100*N.mf_incr, S.mfMix);
rp = rl(rp, 'No-mix: t_BO core/fan = %.4e / %.4e s, H_min = %.3f / %.3f mm, N_max (10x rule) = %d / %d', tBO(1), tBO(2), Hmin(1)*1e3, Hmin(2)*1e3, Nmax(1), Nmax(2));
rp = rl(rp, 'No-mix: W/H = %.2f, B = %.4f, vee-gutter D core/fan = %.3f / %.3f mm, t_s = %.4e / %.4e s, t_s/t_BO = %.2f / %.2f', WH, B, D(1)*1e3, D(2)*1e3, ts(1), ts(2), N.ts_ratio(1), N.ts_ratio(2));
rp = rl(rp, 'No-mix: fan-stream spoke width for t_s = 10 t_BO: D = %.3f mm (spokes need matching core-side blockage compensation)', Dspoke*1e3);
N.rep = rp;
end

