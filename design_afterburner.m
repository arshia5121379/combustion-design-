function A = design_afterburner(R)
C = consts();
K = kin_mechanism();
rep = {};
fprintf('\n=== AFTERBURNER: Sec. 9.3 procedure (defaults = Sec. 9.4.2 example) ===\n');

%% Step 1: station data (Tables 9.E1, 9.E5)
fprintf('--- Step 1: station data (Tables 9.E1, 9.E5) ---\n');
I.mdot6  = ask('Core-gas mass flow at station 6 [kg/s]', 118.65*C.lbm);
I.Pt6    = ask('Total pressure Pt6 [Pa]', 78.129*C.psi);
I.Tt6    = ask('Total temperature Tt6 [K]', 1983.04*C.degR);
I.M6     = ask('Mach number at station 6', 0.3702);
I.A6     = ask('Area A6 [m^2]', 1.549*C.ft2);
I.ri6    = ask('Inner radius of core duct at station 6 [m] (book 11.9 in)', 11.9*C.in);
I.mdot16 = ask('Bypass-air mass flow at station 16 [kg/s]', 109.98*C.lbm);
I.Pt16   = ask('Total pressure Pt16 [Pa]', 83.391*C.psi);
I.Tt16   = ask('Total temperature Tt16 [K]', 893.29*C.degR);
I.M16    = ask('Mach number at station 16', 0.4725);
I.A16    = ask('Area A16 [m^2]', 0.719*C.ft2);
I.mdot6A = ask('Mixed flow at station 6A [kg/s]', 228.63*C.lbm);
I.Pt6A   = ask('Total pressure Pt6A [Pa]', 76.859*C.psi);
I.P6A    = ask('Static pressure P6A [Pa]', 68.248*C.psi);
I.Tt6A   = ask('Total temperature Tt6A [K]', 1513.71*C.degR);
I.A6A    = ask('Area A6A [m^2]', 2.338*C.ft2);
I.g6A    = ask('Specific-heat ratio gamma at 6A', 1.336);
I.mfAB   = ask('Afterburner fuel mass flow [kg/s]', 8.7033*C.lbm);
I.Pt7    = ask('Target total pressure Pt7 [Pa]', 73.016*C.psi);
I.mdot7  = ask('Mass flow at station 7 [kg/s]', 237.33*C.lbm);
I.A61    = ask('Flameholder station area A6.1 [m^2]', 5.378*C.ft2);
I.ro     = ask('Maximum afterburner outer radius ro [m] (book 15.7 in)', 15.7*C.in);

%% Composition and energy closure (from the main burner, or user input)
if isfield(R, 'main')
    phi4 = R.main.res.phi4;
    m4 = R.main.in.mdot4;
    dTmax = R.main.res.dTmax;
    fprintf('    station-4 composition and dTmax taken from the main-burner design\n');
else
    phi4 = ask('Equivalence ratio at station 4 (book 0.3784)', 0.3784);
    m4 = ask('Mass flow of station-4 products [kg/s]', 106.94*C.lbm);
    dTmax = ask('Energy scale dTmax = fst*h/cp [K] (book about 2172)', 2172);
end
mair = I.mdot6A - m4;                                   % cooling + bypass air (book 121.69 lbm/s)
% Afterburner exit total temperature: heat addition, Eq. (9.23) with eps = 1 (complete combustion).
% (The old isentropic relation Tt6A*(Pt7/Pt6A)^((g-1)/g) is a pressure-loss relation and gave Tt7 < Tt6A,
%  so the core-stream fuel in the no-mix design became negative -> fzero sign error.)
phiAB = I.mfAB/(C.fst*I.mdot6A);                        % added equivalence ratio, as Eq. (9.90)
Tt7_est = I.Tt6A + phiAB*dTmax;                          % heat-addition estimate, K
Tt7_book_R = NaN;                                       % <-- type the Table 9.E1 Tt7 here in R (e.g. 3600); NaN = use estimate
if isnan(Tt7_book_R)
    Tt7_def = Tt7_est;
    srcTxt = 'heat-addition estimate, Tt6A + phi_AB*dTmax';
else
    Tt7_def = Tt7_book_R*C.degR;                        % book value converted from R to K
    srcTxt = sprintf('book value %.2f R x 5/9', Tt7_book_R);
end
fprintf('    Tt7 default = %.2f K  (= %.1f R)  [%s]\n', Tt7_def, Tt7_def/C.degR, srcTxt);
fprintf('    reference: Tt6A = %.2f K (%.1f R), phi_AB = %.4f, dTmax = %.1f K\n', I.Tt6A, I.Tt6A/C.degR, phiAB, dTmax);
I.Tt7 = ask('Afterburner exit total temperature Tt7 [K]', Tt7_def);
if I.Tt7 <= I.Tt6A
    error('Tt7 must be above Tt6A (%.1f K) for an afterburner.', I.Tt6A);
end
fprintf('    Tt7 used = %.2f K (%.1f R)\n', I.Tt7, I.Tt7/C.degR);
RR = ask('Recirculation ratio RR of the flameholder mixing layer (book 0.5)', 0.5);
thr = 0.5;                                              % ignition criterion on fuel conversion

%% Step 2: diffuser 6A -> 6.1 (Sec. 9.3.2.2; Eqs. 9.122-9.128)
fprintf('--- Step 2: diffuser 6A -> 6.1 (Eqs. 9.122-9.128) ---\n');
ro1 = I.ro;
ri1 = sqrt(ro1^2 - I.A6A/pi);
H1 = ro1 - ri1;
rm1 = (ro1 + ri1)/2;
q1 = I.Pt6A - I.P6A;
AR = I.A61/I.A6A;
etaM = ask('Flat-wall diffusion efficiency eta_Dm (book 0.90)', 0.90);
GD = diffuser_grid_search(etaM, AR, 4.5);
fprintf('    GRID SEARCH (2*theta = 9 deg, 4 < L/H1 < 20, 1.5 < AR < 4, eta_Dm = %.2f):\n', etaM);
fprintf('      global optimum : AR = %.3f, L/H1 = %.2f, Am/A1 = %.3f, eta_D = %.4f\n', GD.AR_g, GD.Lr_g, GD.x_g, GD.eta_g);
if GD.valid
    fprintf('      at design AR = %.3f: best L/H1 = %.2f, Am/A1 = %.4f, eta_D = %.4f\n', AR, GD.Lr_best, GD.x_best, GD.eta_best);
    fprintf('      Eq. (9.103)/(9.104): L/H1 = %.2f, Am/A1 = %.4f, eta_D = %.4f\n', GD.Lr_an, GD.x_an, GD.eta_an);
else
    warning('Design AR = %.3f is outside 1.5-4: grid optimum not used, Eq. (9.103) applied.', AR);
end
useGrid = ask('Section m area: 1 = grid-search optimum, 0 = analytic Eq. (9.103)', 1);
if useGrid == 1 && GD.valid
    Am = GD.x_best*I.A6A;
else
    Am = etaM*AR*I.A6A;                                 % Eq. (9.103)
end
rep = rl(rep, 'Diffuser grid search (2theta = 9 deg, 4<L/H1<20, 1.5<AR<4, eta_Dm = %.2f): global optimum AR = %.3f, L/H1 = %.2f, Am/A1 = %.3f, eta_D = %.4f', ...
    etaM, GD.AR_g, GD.Lr_g, GD.x_g, GD.eta_g);
if useGrid == 1 && GD.valid
    usedStr = 'grid';
else
    usedStr = 'analytic';
end
rep = rl(rep, 'Grid search at design AR = %.4f: best L/H1 = %.2f, Am/A1 = %.4f, eta_D = %.4f; analytic Eq. (9.103)/(9.104): L/H1 = %.2f, Am/A1 = %.4f, eta_D = %.4f; used: %s', ...
    AR, GD.Lr_best, GD.x_best, GD.eta_best, GD.Lr_an, GD.x_an, GD.eta_an, usedStr);
rim = sqrt(ro1^2 - Am/pi);
rmm = (ro1 + rim)/2;
Hm = ro1 - rim;
Lm = (rm1*H1/rmm)*((Am/I.A6A) - 1)/(2*tan(4.5*C.deg)); % Eq. (9.127)
etaC = (etaM*AR^2*(1 - (I.A6A/Am)^2) + 2*(AR*I.A6A/Am - 1))/(AR^2 - 1);   % Eq. (9.128)
ri2 = sqrt(max(ro1^2 - I.A61/pi, 0));
H2 = ro1 - ri2;
Ld = H2 - Hm;                                           % dump (tailpipe) length
Cpid = 1 - 1/AR^2;
dPq_D = Cpid*(1 - etaC);                                % Eq. (9.66)
Pt61 = I.Pt6A - dPq_D*q1;                               % Eq. (9.66)
P61 = I.P6A + etaC*Cpid*q1;                             % Eqs. (9.62)-(9.64)
q61 = Pt61 - P61;
if q61 <= 0
    error('Non-positive dynamic pressure at station 6.1: check the diffuser inputs.');
end
M61 = sqrt(2*q61/(I.g6A*P61));
T61 = I.Tt6A/(1 + (I.g6A - 1)/2*M61^2);
rho61 = P61/(C.Rp*T61);
U61 = I.mdot6A/(rho61*I.A61);                           % approach velocity U1 = U6.1
fprintf('    AR = %.3f, optimum Am = %.3f ft^2, eta_D = %.4f, Lm = %.2f mm, tailpipe Ld = %.2f mm\n', ...
    AR, Am/C.ft2, etaC, Lm*1e3, Ld*1e3);
fprintf('    station 6.1: P = %.1f kPa, M = %.4f, U1 = %.2f m/s\n', P61/1e3, M61, U61);
rep = rl(rep, 'Diffuser 6A->6.1: AR = %.4f, eta_Dm = %.3f, optimum Am = %.4f ft^2, combined eta_D = %.4f', ...
    AR, etaM, Am/C.ft2, etaC);
rep = rl(rep, 'Lengths: Lm = %.2f mm (%.2f in), tailpipe Ld = %.2f mm (%.2f in), rm1 = %.2f mm, rim = %.2f mm', ...
    Lm*1e3, Lm/C.in, Ld*1e3, Ld/C.in, rm1*1e3, rim*1e3);
rep = rl(rep, 'Station 6.1: Pt = %.3f psi, P = %.3f psi, q = %.4f psi, M = %.4f, U1 = %.2f m/s', ...
    Pt61/C.psi, P61/C.psi, q61/C.psi, M61, U61);

%% Step 3: mixer estimate (Sec. 9.3.2.1; Eqs. 9.52-9.58)
fprintf('--- Step 3: mixer estimate (Eqs. 9.52-9.58) ---\n');
[U6, rho6, T6s, P6s] = station_flow(I.Pt6, I.Tt6, I.M6, 1.30, C.Rp);
[U16, rho16, T16s, P16s] = station_flow(I.Pt16, I.Tt16, I.M16, 1.40, C.Ra);   %#ok<ASGLU>
rv = U16/U6;                                            % velocity ratio r
sd = rho16/rho6;                                        % density ratio s
Cdelta = ask('Shear-layer growth constant C_delta (0.25-0.45; book max 0.45)', 0.45);
dd_dx = Cdelta*ab_growth(rv, sd);
ri16 = sqrt(max(ro1^2 - I.A16/pi, 0));
H16 = ro1 - ri16;
Lmix_est = H16/dd_dx;                                   % length for the bypass layer to span H16
fprintf('    r = %.4f, s = %.3f, d(delta)/dx = %.5f, mixing-length estimate = %.2f m\n', rv, sd, dd_dx, Lmix_est);
rep = rl(rep, 'Mixer: r = %.4f, s = %.4f, d(delta)/dx = %.5f (C_delta = %.2f), bypass height %.2f mm, length estimate %.2f m', ...
    rv, sd, dd_dx, Cdelta, H16*1e3, Lmix_est);
rep = rl(rep, 'Mixer note: the book finds that complete mixing needs a much longer mixer; mixer length is an input.');

%% Step 4: vee-gutter flameholders and kinetics (Sec. 9.3.2.5; Eqs. 9.129-9.137)
fprintf('--- Step 4: vee-gutter flameholders and blowout (Eqs. 9.129-9.137) ---\n');
WH = ask('Wake width ratio W/H (book 0.4; optimum 0.5)', 0.4);
B = 1.034*WH - 0.1;                                     % Eq. (9.137), half-angle 15 deg
CD = WH^2/(B*(1 - WH)^2);                               % Eq. (9.84) with Eq. (9.87)
dry = CD*B;                                             % dry loss, Eq. (9.85) with tau = 1
U2 = U61/(1 - WH);                                      % Eq. (9.133)
Ns = 4*WH*(1 - WH);                                     % from Eq. (9.134)
Nr = ask('Number of vee-gutter rings (book 3)', 3);
Htot = ro1 - ri2;                                       % total flow height at station 6.1
Hch = Htot/Nr;                                          % channel height per ring
thSp = ask('Flame-spread included angle [deg] (book 17)', 17);
Lsp = (Hch/2)/tan(thSp/2*C.deg);                        % gutter tip to wall
Lrec = 4*WH*Hch;                                        % recirculation length, Eq. (9.132)
ts = 4*WH*Hch/U2;                                       % mixing-layer residence time, Eq. (9.132)
[nin, nS, phiF] = kin_ab_comp(K, phi4, m4, mair, I.mfAB, RR);
kinAB = kin_design(K, nin, nS, I.Tt6A, P61, phiF, dTmax, ts, thr);   % WSR at t_s, Table 9.3
tBO_user = ask('Blowout residence time t_BO [s] (0 = compute with Table 9.3)', 0);
if tBO_user > 0
    tBO = tBO_user;
else
    tBO = kinAB.tBO;
end
Hmin = U61*tBO/Ns;                                      % Eq. (9.134)
Dg = B*Hch;                                             % gutter lateral dimension D
Dmin = B*Hmin;
Nmax = floor(Htot/(10*Dmin));                           % book rule: D >= 10 D_min
if Hch < Hmin
    warning('Channel height is below H_min: use fewer rings.');
end
fprintf('    phi_AB (local) = %.4f, t_BO = %.4e s (book KINETX 8.5e-5 s)\n', phiF, tBO);
fprintf('    W/H = %.3f, B = %.4f, C_D = %.4f, dry (dPt/q1) = %.4f, H_min = %.3f mm\n', WH, B, CD, dry, Hmin*1e3);
fprintf('    %d rings: channel H = %.3f mm, D = %.3f mm, flame spread length = %.2f mm, ts/t_BO = %.2f\n', ...
    Nr, Hch*1e3, Dg*1e3, Lsp*1e3, ts/tBO);
rep = rl(rep, 'Flameholders: W/H = %.3f, B = D/H = %.4f, C_D = %.4f, dry (dPt/q1) = %.4f', WH, B, CD, dry);
rep = rl(rep, 'Rings: N = %d, channel H = %.3f mm (%.3f in), D = %.3f mm (%.3f in), N_max (book rule) = %d', ...
    Nr, Hch*1e3, Hch/C.in, Dg*1e3, Dg/C.in, Nmax);
rep = rl(rep, 'Blowout: t_BO = %.4e s, H_min = %.3f mm (%.4f in), U1 = %.2f m/s, t_s = %.4e s, t_s/t_BO = %.2f', ...
    tBO, Hmin*1e3, Hmin/C.in, U61, ts, ts/tBO);
rep = rl(rep, 'Flame spread: gutter tip to wall = %.2f mm (%.2f in) for included angle %.1f deg; recirculation length 4W = %.2f mm', ...
    Lsp*1e3, Lsp/C.in, thSp, Lrec*1e3);

%% Step 5: total pressure loss and station 7 (Eqs. 9.83-9.86, 9.121)
fprintf('--- Step 5: total pressure loss and station 7 (Eqs. 9.83-9.86) ---\n');
tau_AB = I.Tt7/I.Tt6A;                                  % tau_AB = Tt7/Tt6.1
dPq_wet = (tau_AB - 1) + CD*B;                          % Eq. (9.85), wet
Pt7_wet = Pt61 - q61*dPq_wet;
Pt7_dry = Pt61 - q61*dry;
fprintf('    Pt7 wet = %.3f psi (target %.3f), dry = %.3f psi\n', Pt7_wet/C.psi, I.Pt7/C.psi, Pt7_dry/C.psi);
rep = rl(rep, 'Pt7: wet = %.3f psi (target %.3f psi), dry = %.3f psi, tau_AB = Tt7/Tt6.1 = %.4f', ...
    Pt7_wet/C.psi, I.Pt7/C.psi, Pt7_dry/C.psi, tau_AB);
Rp = C.Rp;
g7 = 1.30;
tgt = I.mdot7*sqrt(Rp*I.Tt7)/(I.A61*Pt7_wet);
fM = @(Mx) sqrt(g7)*Mx*(1 + (g7 - 1)/2*Mx^2)^(-(g7 + 1)/(2*(g7 - 1))) - tgt;
M7 = fzero(fM, [1e-4 0.999]);                           % subsonic root, corrected station 7
T7 = I.Tt7/(1 + (g7 - 1)/2*M7^2);
P7 = Pt7_wet/(1 + (g7 - 1)/2*M7^2)^(g7/(g7 - 1));
U7 = M7*sqrt(g7*Rp*T7);
AovAs = (1/M7)*((2/(g7 + 1))*(1 + (g7 - 1)/2*M7^2))^((g7 + 1)/(2*(g7 - 1)));
Astar = I.A61/AovAs;
Ithr = P7*I.A61*(1 + g7*M7^2);                          % stream thrust at station 7
rep = rl(rep, 'Station 7 (corrected): M = %.4f, P = %.3f psi, U = %.2f m/s, A* = %.4f ft^2, stream thrust = %.1f kN', ...
    M7, P7/C.psi, U7, Astar/C.ft2, Ithr/1e3);
fprintf('    station 7: M = %.4f, P = %.2f psi, U = %.1f m/s\n', M7, P7/C.psi, U7);

%% Alternate no-mix afterburner (Sec. 9.4.2.6)
fprintf('--- Step 6: alternate no-mix afterburner (Sec. 9.4.2.6) ---\n');
N = [];
if ask('Evaluate the alternate no-mix afterburner? (1 = yes, 0 = no)', 1) == 1
    SN = struct('Am', Am, 'etaD', etaM, 'ro1', ro1, 'rim', rim, 'U6', U6, 'U16', U16, 'P6', P6s, 'P16', P16s, ...
        'm4', m4, 'phi4', phi4, 'dTmax', dTmax, 'RR', RR, 'phiMix', phiF, 'mfMix', I.mfAB, ...
        'WH', ask('No-mix wake width ratio W/H (optimum 0.5)', 0.5));
    N = nomix_ab(I, K, SN);
    rep = [rep, N.rep];
end

%% WSR state sweep (Fig. 9.8 / 9.10 style) for the afterburner
taus = logspace(-7, -3, 13);
S = kin_struct(K, nin, I.Tt6A, P61, phiF, dTmax);
[sweep_eps, sweep_T] = kin_sweep(S, nS, taus);

%% geometry, x = 0 at station 6A (mixer entry)
Lduct = ask('Upstream ducting length from station 6/16 to 6A [m] (book 12 in)', 12*C.in);
Lmixer = ask('Mixer length between 6A and diffuser entry [m] (0 = none)', 0);
x6 = Lmixer + Lm + Ld;                                  % station 6.1
xend = x6 + Lsp;
rk = ri2 + ((1:Nr) - 0.5)*Hch;                          % radial centres of the vee-gutter rings
xtip = x6 + (Dg/2)/tan(15*C.deg);                       % gutter trailing edge (half-angle 15 deg)
rsplit = sqrt(I.ri6^2 + I.A6/pi);                       % core/bypass splitter radius
G.outer = [-Lduct ro1; xend ro1];                       % outer wall
G.core_inner = [-Lduct I.ri6; 0 ri1];                   % core-duct inner wall
G.inner = [0 ri1; Lmixer ri1; Lmixer + Lm rim; Lmixer + Lm 0; x6 0];   % centre body + dump
G.bypass_split = [-Lduct rsplit; 0 rsplit];             % core / bypass splitter
G.gutters = zeros(0, 2);
G.flame = zeros(0, 2);
G.spray = zeros(0, 2);
for k = 1:Nr
    yc = rk(k);
    G.gutters = [G.gutters; xtip yc - Dg/2; x6 yc; xtip yc + Dg/2; NaN NaN];   % apex (x6) points upstream, open side faces downstream   %#ok<AGROW>
    G.flame = [G.flame; xtip yc + Dg/2; xend yc + Hch/2; NaN NaN; xtip yc - Dg/2; xend yc - Hch/2; NaN NaN];   % flame spreads from the trailing edge %#ok<AGROW>
    G.spray = [G.spray; x6 - 0.02*Lm yc]; %#ok<AGROW>
end
G.station_pts = [0 ro1; Lmixer + Lm ro1; x6 ro1];      % stations 6A, m, 6.1
G.x6 = x6;
G.xend = xend;
G.xtip = xtip;
if ~isempty(N)
    xm = Lmixer + Lm;
    G.nm_slip = [-Lduct rsplit; xm N.rslip];
    G.nm_gutters = zeros(0, 2);
    for s = 1:2
        for k = 1:N.Nv(s)
            if s == 1
                yc = rim + (k - 0.5)*N.Hch(s);
            else
                yc = N.rslip + (k - 0.5)*N.Hch(s);
            end
            xt = xm + (N.D(s)/2)/tan(15*C.deg);
            G.nm_gutters = [G.nm_gutters; xt yc - N.D(s)/2; xm yc; xt yc + N.D(s)/2; NaN NaN];   %#ok<AGROW>
        end
    end
end
A.geo = mm_struct(G);

%% pack results
A.in = I;
A.res = struct('AR', AR, 'Am', Am, 'A6A', I.A6A, 'Lm', Lm, 'Ld', Ld, 'etaM', etaM, 'etaC', etaC, ...
    'Pt61', Pt61, 'P61', P61, 'q61', q61, 'M61', M61, 'T61', T61, 'U61', U61, 'U2', U2, ...
    'rv', rv, 'sd', sd, 'dd_dx', dd_dx, 'Lmix_est', Lmix_est, 'Cdelta', Cdelta, ...
    'WH', WH, 'B', B, 'CD', CD, 'dry', dry, 'tBO', tBO, 'Hmin', Hmin, 'Nr', Nr, 'Htot', Htot, ...
    'Hch', Hch, 'Dg', Dg, 'Nmax', Nmax, 'Lsp', Lsp, 'Lrec', Lrec, 'ts', ts, ...
    'Pt7_wet', Pt7_wet, 'Pt7_dry', Pt7_dry, 'M7', M7, 'P7', P7, 'U7', U7, 'Astar', Astar, ...
    'thrust', Ithr, 'phiF', phiF, 'dTmax', dTmax, 'ro1', ro1, 'ri1', ri1, 'rim', rim, ...
    'ri2', ri2, 'H2', H2, 'Hm', Hm, 'rm1', rm1, 'rmm', rmm, 'ri16', ri16, 'H16', H16, ...
    'tau_AB', tau_AB, 'dPq_wet', dPq_wet, 'Lduct', Lduct, 'Lmixer', Lmixer, ...
    'x6', x6, 'xend', xend, 'Ltotal', Lduct + Lmixer + Lm + Ld + Lsp, 'rsplit', rsplit);
A.kin = kinAB;
A.grid = GD;
A.nomix = N;
A.sweep = struct('tau', taus, 'eps', sweep_eps, 'T', sweep_T);
A.comp = struct('nin', nin, 'nS', nS);
A.rep = rep;
rep = rl(rep, 'Total afterburner axial length (ducts + mixer + diffuser + tailpipe + flame zone) = %.2f mm (%.2f in)', ...
    A.res.Ltotal*1e3, A.res.Ltotal/C.in);
A.rep = rep;
end

%% ======================================================================
%%  WSR KINETICS:  Eq. (9.19) with the Table 9.3 mechanism
%% ======================================================================
