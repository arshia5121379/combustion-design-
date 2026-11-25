function M = design_main_burner()
C = consts();
K = kin_mechanism();
rep = {};
fprintf('\n=== MAIN BURNER: Sec. 9.2 procedure (defaults = Sec. 9.4.1 example) ===\n');

%% Step 1: design-point station data (Tables 9.E1, 9.E2)
fprintf('--- Step 1: design-point station data (Tables 9.E1, 9.E2) ---\n');
I.mdot31 = ask('Air mass flow at station 3.1 [kg/s]', 104.24*C.lbm);
I.mdotf  = ask('Main-burner fuel mass flow [kg/s]', 2.7017*C.lbm);
I.Pt31   = ask('Total pressure Pt3.1 [Pa]', 585.114*C.psi);
I.Tt31   = ask('Total temperature Tt3.1 [K]', 1659.99*C.degR);
I.P31    = ask('Static pressure P3.1 [Pa]', 550.205*C.psi);
I.A31    = ask('Annulus area A3.1 [m^2]', 0.194*C.ft2);
I.rm31   = ask('Mean radius rm3.1 [m]', 9.0*C.in);
I.Pt4    = ask('Total pressure Pt4 [Pa]', 555.859*C.psi);
I.Tt4    = ask('Total temperature Tt4 [K]', 3138.8*C.degR);
I.mdot4  = ask('Mass flow at station 4 [kg/s]', 106.94*C.lbm);
I.A4     = ask('Annulus area A4 [m^2]', 0.144*C.ft2);
I.rm4    = ask('Mean radius rm4 [m]', 7.0*C.in);
I.A32    = ask('Reference area A3.2 [m^2] (first-cut value)', 0.677*C.ft2);
I.Pt32   = ask('Total pressure Pt3.2 [Pa]', 579.263*C.psi);
I.P32    = ask('Static pressure P3.2 [Pa]', 576.537*C.psi);
I.Tt32   = ask('Total temperature Tt3.2 [K]', 1659.99*C.degR);
I.M32    = ask('Mach number at station 3.2', 0.0821);
[H31, ro31, ri31] = annulus(I.A31, I.rm31);
[H4, ro4, ri4] = annulus(I.A4, I.rm4);
rm31 = I.rm31;
rep = rl(rep, 'Station 3.1: H = %.2f mm, ro = %.2f mm, ri = %.2f mm', H31*1e3, ro31*1e3, ri31*1e3);
rep = rl(rep, 'Station 4  : H = %.2f mm, ro = %.2f mm, ri = %.2f mm', H4*1e3, ro4*1e3, ri4*1e3);

%% Step 2: casing layout (Sec. 9.2.3.3, Table 9.E3)
fprintf('--- Step 2: casing layout (Sec. 9.2.3.3, Table 9.E3) ---\n');
fprintf('    Design A: ro3.2 = ro3.1 = %.2f mm ;  Design B: ro3.2 = ro4 = %.2f mm\n', ro31*1e3, ro4*1e3);
lay = ask('Layout: 1 = Design A, 2 = Design B, 3 = custom ro3.2', 2);
switch lay
    case 1
        ro32 = ro31;
    case 2
        ro32 = ro4;
    otherwise
        ro32 = ask('Custom outer casing radius ro3.2 [m]', ro4);
end
if ro32^2 <= I.A32/pi
    error('Outer radius ro3.2 is too small for the reference area A3.2.');
end
ri32 = sqrt(ro32^2 - I.A32/pi);
H32 = ro32 - ri32;
rm32 = (ro32 + ri32)/2;
% Eq. (9.105): N_noz ~ pi*(ro+ri)_3.2/Hr = A3.2/Hr^2 = (4*pi^2/A3.2)*r_m3.2^2   (Hr = H32)
Nnoz = round((4*pi^2/I.A32)*rm32^2);
Nauto = Nnoz;
for lv = 1:2
    if lv == 1
        roc = ro31;
    else
        roc = ro4;
    end
    ric = sqrt(roc^2 - I.A32/pi);
    Nc = round(pi*(roc + ric)/(roc - ric));
    rep = rl(rep, 'Layout %s: ro3.2 = %.2f mm, ri3.2 = %.2f mm, H3.2 = %.2f mm, Nnoz (Eq. 9.105) = %d', ...
        char('A' + lv - 1), roc*1e3, ric*1e3, (roc - ric)*1e3, Nc);
end
rep = rl(rep, 'Selected: ro3.2 = %.2f mm, ri3.2 = %.2f mm, H3.2 = %.2f mm, rm3.2 = %.2f mm, Nnoz = %d', ...
    ro32*1e3, ri32*1e3, H32*1e3, rm32*1e3, Nnoz);

%% Step 3: diffuser (Sec. 9.1.5.1, 9.2.3.1; Eqs. 9.61-9.68)
fprintf('--- Step 3: diffuser (Sec. 9.1.5.1, 9.2.3.1; Eqs. 9.61-9.68) ---\n');
AR = I.A32/I.A31;
q1 = I.Pt31 - I.P31;
Cpid = 1 - 1/AR^2;                                      % Eq. (9.63)
etaReq = 1 - ((I.Pt31 - I.Pt32)/q1)/Cpid;               % efficiency that fits the allocated loss
fprintf('    AR = A3.2/A3.1 = %.3f ; minimum eta_D from the loss allocation = %.3f\n', AR, etaReq);
etaD = ask('Diffuser efficiency eta_D (book example 0.83)', 0.83);
nsp = ask('Number of splitter plates (0, 1 or 2; book uses 1)', 1);
thD = ask('Flat-wall half-angle [deg] (sweet spot 4.5)', 4.5);
if AR >= 4
    warning('AR >= 4: the dump section is not sized automatically; the flat-wall length is used.');
end
Lsing = H31*(rm31/rm32)*(AR - 1)/(2*tan(thD*C.deg));   % Eq. (9.61), single stream
Leff = Lsing/(nsp + 1);                                 % splitters divide the length
if Leff <= abs(rm31 - rm32)
    error('Diffuser too short for this radius change: add a splitter or change the layout.');
end
dx = sqrt(Leff^2 - (rm31 - rm32)^2);                    % axial length, station 3.1 -> 3.2
dPt_diff = Cpid*(1 - etaD)*q1;                          % Eq. (9.66)
rep = rl(rep, 'Diffuser: AR = %.3f, single-stream length = %.2f mm, splitters = %d, axial length dx = %.2f mm', ...
    AR, Lsing*1e3, nsp, dx*1e3);
rep = rl(rep, 'Diffuser loss: dPt/q1 = %.4f (allocated %.4f); Pt3.2 predicted = %.2f psi (given %.2f psi)', ...
    dPt_diff/q1, (I.Pt31 - I.Pt32)/q1, (I.Pt31 - dPt_diff)/C.psi, I.Pt32/C.psi);

%% Step 4: air partitioning (Sec. 9.2.2; Eqs. 9.88-9.101)
fprintf('--- Step 4: air partitioning (Sec. 9.2.2; Eqs. 9.88-9.101) ---\n');
phi4 = I.mdotf/(C.fst*I.mdot31);                        % Eq. (9.90)
dTmax = (I.Tt4 - I.Tt31)/phi4;                          % Eq. (9.89), K
phi_pz = ask('Primary-zone equivalence ratio phi_pz (book 0.8)', 0.8);
eps_pz = ask('Primary-zone combustion efficiency target eps_pz (book 0.70)', 0.70);
Tg = I.Tt31 + phi_pz*eps_pz*dTmax;                      % Eq. (9.91) solved for Tg
Tm = ask('Liner metal temperature Tm [K] (book 1172.22 K)', 1172.22);
Tc = ask('Cooling air total temperature Tc [K] (book 1660 R)', 1660*C.degR);
coolType = ask('Liner cooling: 1 = film, 2 = transpiration/effusion', 2);
phi_sz = (Tg - I.Tt31)/dTmax;                           % Eq. (9.97)
mu_pz = phi4/phi_pz;                                    % Eq. (9.93)
mu_sz = phi4/phi_sz - mu_pz;                            % Eq. (9.99)
epsc = (Tg - Tm)/(Tg - Tc);                             % Eq. (9.94)
mu_c = cool_fraction(epsc, coolType);                   % Eqs. (9.95)/(9.96)
mu_dz = 1 - (mu_pz + mu_sz + mu_c);                     % Eq. (9.101)
if mu_dz < 0
    warning('Dilution air fraction is negative: raise cooling effectiveness or Tg (Sec. 9.2.2).');
end
fprintf('    Tg = %.1f K (%.0f R), phi4 = %.4f, dTmax = %.1f K\n', Tg, Tg/C.degR, phi4, dTmax);
fprintf('    mu_pz = %.3f, mu_sz = %.3f, mu_c = %.3f, mu_dz = %.3f\n', mu_pz, mu_sz, mu_c, mu_dz);
rep = rl(rep, 'Air partition: phi4 = %.4f, dTmax = %.1f K, Tg = %.1f K (%.0f R)', phi4, dTmax, Tg, Tg/C.degR);
rep = rl(rep, 'Air fractions: mu_pz = %.4f, mu_sz = %.4f, mu_c = %.4f, mu_dz = %.4f (sum = 1)', ...
    mu_pz, mu_sz, mu_c, mu_dz);

%% Step 5: dome and liner height (Eq. 9.109)
fprintf('--- Step 5: dome and liner height (Eq. 9.109) ---\n');
muA = mu_sz + mu_dz;                                    % annulus flow ratio after the PZ
dPq = (I.Pt32 - I.Pt4)/(I.Pt32 - I.P32);                % (dPt/q_r)_MB
alpha = 1 - muA^(2/3)/dPq^(1/3);                        % Eq. (9.109)
if alpha <= 0 || alpha >= 1
    warning('alpha_opt = %.3f is outside (0,1): check the air partition and loss allocation.', alpha);
end
HL = alpha*H32;                                         % liner height
rLo = rm32 + HL/2;  rLi = rm32 - HL/2;                  % liner radii centred on rm3.2
tg = Tg/I.Tt32;                                         % = Tg/Tc (book notation)
dPq_min = (mu_pz/alpha)^2*tg*(2*tg - 1);                % stirring requirement (Sec. 9.4.1.5)
fprintf('    alpha_opt = %.4f, HL = %.2f mm, (dPt/q)_min = %.3f vs allocated %.3f\n', ...
    alpha, HL*1e3, dPq_min, dPq);
rep = rl(rep, 'Liner: alpha_opt = %.4f, HL = %.2f mm (%.4f in), liner ri = %.2f mm, ro = %.2f mm', ...
    alpha, HL*1e3, HL/C.in, rLi*1e3, rLo*1e3);
rep = rl(rep, 'Stirring check: (dPt/q_r)_min = %.3f <= allocated (dPt/q_r)_MB = %.3f', dPq_min, dPq);

%% Step 6: primary-zone swirlers (Eqs. 9.110, 9.111, 9.48, 9.50)
fprintf('--- Step 6: primary-zone swirlers (Eqs. 9.110-9.111, 9.48, 9.50) ---\n');
Ur = I.M32*sqrt(1.4*C.Ra*I.Tt32);                       % reference velocity at 3.2
rho_r = I.mdot31/(I.A32*Ur);                            % continuity at station 3.2
Vj = Ur*sqrt(dPq);                                      % Eq. (9.110)
rh = ask('Swirler hub radius rh [m] (>= 0.5 in)', 0.5*C.in);
CD90 = 0.64;                                            % sharp-edged hole, Eq. (9.33)
asw = ask('Swirler vane angle alpha_sw [deg] (start 45)', 45);
mdot_pz = mu_pz*I.mdot31;                               % primary air
mdot_sw = mdot_pz - 3*I.mdotf;                          % airblast air = 3 lbm per lbm fuel
if mdot_sw <= 0
    error('Primary air is less than the airblast air (3 lbm per lbm fuel): raise phi_pz or reduce the fuel flow.');
end
Asw = mdot_sw/(Nnoz*rho_r*Vj*CD90*cos(asw*C.deg));      % Eq. (9.111)
rt = sqrt(rh^2 + Asw/pi);
Sp = (2/3)*tan(asw*C.deg)*(1 - (rh/rt)^3)/(1 - (rh/rt)^2);   % Eq. (9.48)
Lpz = 2*Sp*rt;                                          % Eq. (9.50)

% ---- primary-zone micromixing check, Eqs. (9.75)-(9.79) ----
% tau_PZ = Tg/Tt3.2 (temperature-rise ratio across the primary zone), A_j = vena-contracta
% area of ALL primary-zone jets (mdot_PZ = rho_j*A_j*V_j, Eq. 9.76), A_L ~ HL^2.
tauPZ  = Tg/I.Tt32;
Aj_pz  = mdot_pz/(rho_r*Vj);                            % total jet area from Eq. (9.76)
AL_Aj  = HL^2/Aj_pz;                                    % A_L/A_j
AL_Aj_min = sqrt(2)*tauPZ;                              % Eq. (9.78)
ts_tm  = (HL^2/(sqrt(2)*tauPZ*Aj_pz))^(2/3);            % Eq. (9.77), must be > 1
tm_mix = (2*HL^2/(tauPZ*Aj_pz))^(1/3)*HL/Vj;            % Eq. (9.75), micromixing time [s]
ts_pz  = HL^3/(tauPZ*Aj_pz*Vj);                         % Eq. (9.76), stay time [s]
dPq_swith = 3;                                          % Swithenbank flameholding limit (Ref. 24)
fprintf('    micromixing: A_L/A_j = %.2f (need > %.2f, Eq. 9.78), t_s/t_m = %.2f (need > 1, Eq. 9.77)\n', ...
    AL_Aj, AL_Aj_min, ts_tm);
fprintf('                 t_m = %.3e s, t_s = %.3e s ; (dPt/q_r) allocated = %.2f vs Swithenbank limit ~%.0f\n', ...
    tm_mix, ts_pz, dPq, dPq_swith);
if ts_tm <= 1 || AL_Aj <= AL_Aj_min
    warning('Primary-zone stay time is shorter than the micromixing time (Eq. 9.77/9.78 not met).');
end
if dPq < dPq_swith
    warning('Total pressure loss coefficient %.2f is below the Swithenbank limit (~3).', dPq);
end
rep = rl(rep, 'Micromixing: A_L/A_j = %.3f (> %.3f required, Eq. 9.78), t_m = %.4e s, t_s = %.4e s, t_s/t_m = %.3f (> 1 required, Eq. 9.77)', ...
    AL_Aj, AL_Aj_min, tm_mix, ts_pz, ts_tm);
rep = rl(rep, 'Stirring: (dPt/q_r)_min (Eq. 9.79) = %.3f, allocated = %.3f, Swithenbank limit ~ %.0f', dPq_min, dPq, dPq_swith);
if rt > HL/2
    warning('Swirler tip radius exceeds HL/2: change the angle or nozzle count.');
end
if Sp < 0.6 || Sp > 1.0
    warning('Swirl number S is %.3f, outside 0.6-1.0 (Sec. 9.1.4.4).', Sp);
end
fprintf('    Ur = %.2f m/s, rho_r = %.3f kg/m^3, Vj = %.1f m/s\n', Ur, rho_r, Vj);
fprintf('    swirler: rt = %.3f mm, swirl number = %.3f, Lpz = %.2f mm\n', rt*1e3, Sp, Lpz*1e3);
rep = rl(rep, 'Reference: Ur = %.2f m/s, rho_r = %.4f kg/m^3, jet velocity Vj = %.2f m/s', Ur, rho_r, Vj);
rep = rl(rep, 'Swirlers: Asw = %.3f in^2 per nozzle, rt = %.3f mm (%.3f in), rh = %.3f mm', ...
    Asw/C.in^2, rt*1e3, rt/C.in, rh*1e3);
rep = rl(rep, 'Swirl number = %.4f (target 0.6-1.0), Lpz = 2 S rt = %.2f mm', Sp, Lpz*1e3);

% ---- swirler geometry specification (vanes, pitch, turning angle, lengths) ----
if asw <= 0 || asw >= 90
    error('Swirler vane angle must lie between 0 and 90 deg.');
end
Nvane = round(ask('Number of vanes (blades) per swirler', 12));
if Nvane < 3
    error('A swirler needs at least 3 vanes.');
end
sigma = ask('Vane solidity c/s at mean radius (chord / circumferential pitch)', 1.0);
rmS = (rt + rh)/2;                                      % swirler mean radius
spH = 2*pi*rh/Nvane;  spM = 2*pi*rmS/Nvane;  spT = 2*pi*rt/Nvane;   % circumferential pitch hub/mean/tip
cvane = sigma*spM;                                      % vane chord
Lsw = cvane*cos(asw*C.deg);                             % axial length of the swirler
Hsw = rt - rh;                                          % vane radial span
hpH = 2*pi*rh/tan(asw*C.deg); hpM = 2*pi*rmS/tan(asw*C.deg); hpT = 2*pi*rt/tan(asw*C.deg);  % helical pitch
wthr = spM*cos(asw*C.deg);                              % throat between adjacent vanes (mean radius)
fprintf('    SWIRLER SPEC: vanes = %d, rt = %.3f mm, rh = %.3f mm, vane span = %.3f mm\n', Nvane, rt*1e3, rh*1e3, Hsw*1e3);
fprintf('                  flow turning angle = %.1f deg from axial, swirl number = %.3f\n', asw, Sp);
fprintf('                  circumferential pitch hub/mean/tip = %.3f / %.3f / %.3f mm\n', spH*1e3, spM*1e3, spT*1e3);
fprintf('                  helical pitch hub/mean/tip = %.2f / %.2f / %.2f mm per turn\n', hpH*1e3, hpM*1e3, hpT*1e3);
fprintf('                  vane chord = %.3f mm (solidity %.2f), axial swirler length = %.3f mm, throat = %.3f mm\n', cvane*1e3, sigma, Lsw*1e3, wthr*1e3);
rep = rl(rep, 'Swirler spec: N_vanes = %d per swirler, rt = %.3f mm, rh = %.3f mm, mean radius = %.3f mm, vane span = %.3f mm', ...
    Nvane, rt*1e3, rh*1e3, rmS*1e3, Hsw*1e3);
rep = rl(rep, 'Swirler spec: flow turning angle = %.2f deg (from axial), swirl number S = %.4f', asw, Sp);
rep = rl(rep, 'Swirler spec: circumferential pitch hub/mean/tip = %.3f / %.3f / %.3f mm; helical pitch hub/mean/tip = %.2f / %.2f / %.2f mm per turn', ...
    spH*1e3, spM*1e3, spT*1e3, hpH*1e3, hpM*1e3, hpT*1e3);
rep = rl(rep, 'Swirler spec: vane chord = %.3f mm (solidity c/s = %.2f), axial swirler length = %.3f mm, throat width = %.3f mm, primary-zone length Lpz = %.2f mm', ...
    cvane*1e3, sigma, Lsw*1e3, wthr*1e3, Lpz*1e3);

%% Step 7: secondary holes (Eqs. 9.106-9.116)
fprintf('--- Step 7: secondary holes (Eqs. 9.106-9.116) ---\n');
qj = dPq;                                               % Eq. (9.36)
qA_s = (muA/(1 - alpha))^2;                             % annulus flow after the PZ
qL_s = tg*(mu_pz/alpha)^2;                              % liner flow at PZ exit
Hs = jet_holes(qj, qA_s, qL_s, HL, 4, mu_sz*I.mdot31, rho_r, Vj, CD90, Nnoz);
Lsz = 2*HL;                                             % Eq. (9.116)
fprintf('    secondary: Ymax/dj = %.3f, dj = %.3f mm, dh = %.3f mm, holes = %.0f (%.1f per nozzle)\n', ...
    Hs.YdJ, Hs.dj*1e3, Hs.dh*1e3, Hs.Ntot, Hs.Nper);
rep = rl(rep, 'Secondary holes: qA/qr = %.4f, qL/qr = %.4f, theta = %.2f deg, Ymax/dj = %.3f', ...
    qA_s, qL_s, Hs.theta/C.deg, Hs.YdJ);
rep = rl(rep, 'Secondary: dj = %.3f mm, dh = %.3f mm, total holes = %.0f (%.1f per nozzle), Lsz = %.2f mm', ...
    Hs.dj*1e3, Hs.dh*1e3, Hs.Ntot, Hs.Nper, Lsz*1e3);

%% Step 8: dilution holes (Sec. 9.2.2.4, Eqs. 9.117-9.120)
fprintf('--- Step 8: dilution holes (Eqs. 9.117-9.120) ---\n');
qA_d = (mu_dz/(1 - alpha))^2;                           % annulus flow after the secondary holes
qL_d = tg*((mu_pz + mu_sz)/alpha)^2;                    % liner flow after the secondary holes
Hd = jet_holes(qj, qA_d, qL_d, HL, 3, mu_dz*I.mdot31, rho_r, Vj, CD90, Nnoz);
Ldz = 1.5*HL;                                           % guideline, Sec. 9.2.3.8
Ltr = H32;                                              % transition duct, Sec. 9.2.3.9
Lliner = Lpz + Lsz + Ldz;
fprintf('    dilution: Ymax/dj = %.3f, dj = %.3f mm, dh = %.3f mm, holes = %.0f\n', ...
    Hd.YdJ, Hd.dj*1e3, Hd.dh*1e3, Hd.Ntot);
rep = rl(rep, 'Dilution holes: qA/qr = %.4f, qL/qr = %.4f, theta = %.2f deg, Ymax/dj = %.3f', ...
    qA_d, qL_d, Hd.theta/C.deg, Hd.YdJ);
rep = rl(rep, 'Dilution: dj = %.3f mm, dh = %.3f mm, total holes = %.0f (%.1f per nozzle), Ldz = %.2f mm', ...
    Hd.dj*1e3, Hd.dh*1e3, Hd.Ntot, Hd.Nper, Ldz*1e3);
rep = rl(rep, 'Liner length: Lpz + Lsz + Ldz = %.2f + %.2f + %.2f = %.2f mm (%.2f in); transition duct %.2f mm', ...
    Lpz*1e3, Lsz*1e3, Ldz*1e3, Lliner*1e3, Lliner/C.in, Ltr*1e3);

%% Step 9: WSR kinetics for the primary zone (Eq. 9.19 with Table 9.3)
fprintf('--- Step 9: primary-zone kinetics (Eq. 9.19 with Table 9.3) ---\n');
kinPZ = [];
doKin = ask('Run WSR kinetics for the primary zone? (1 = yes, 0 = no)', 1);
if doKin == 1
    Vpz = pi*rt^2*Lpz/8;                                % micromixed volume, Sec. 9.1.4.4
    mdot_noz = (mdot_pz + I.mdotf)/Nnoz;                % air + fuel per nozzle
    rho_g = I.Pt32/(C.Ra*Tg);                           % reactor density at Tg
    tau_pz = rho_g*Vpz/mdot_noz;                        % residence time, Sec. 9.4.1.6
    nF = kin_fresh_comp(K, phi_pz);
    nS = kin_hot_start(K, kin_burned_comp(K, phi_pz));
    kinPZ = kin_design(K, nF, nS, I.Tt32, I.Pt32, phi_pz, dTmax, tau_pz, 0.5);
    fprintf('    tau_pz = %.3e s, WSR eps = %.4f (target %.2f), T = %.0f K (design Tg = %.0f K)\n', ...
        tau_pz, kinPZ.eps, eps_pz, kinPZ.T, Tg);
    fprintf('    blowout residence time t_BO = %.3e s (book KINETX 4.4e-6 s); tau/t_BO = %.2f\n', ...
        kinPZ.tBO, tau_pz/kinPZ.tBO);
    rep = rl(rep, 'Primary-zone WSR (Table 9.3): tau = %.4e s, eps = %.4f, T = %.1f K, t_BO = %.4e s, tau/t_BO = %.2f', ...
        tau_pz, kinPZ.eps, kinPZ.T, kinPZ.tBO, tau_pz/kinPZ.tBO);
end

%% Step 10: 2-D geometry (x = 0 at station 3.1, meridional plane)
xL = dx + Lliner;
x4 = xL + Ltr;
G.outer = [0 ro31; dx ro32; xL ro32; x4 ro4];           % outer casing (flat along the liner, then to station 4)
G.inner = [0 ri31; dx ri32; xL ri32; x4 ri4];           % inner casing (flat, parallel to the liner, then to station 4)
G.liner_o = [dx rLo; xL rLo];                           % liner outer wall
G.liner_i = [dx rLi; xL rLi];                           % liner inner wall
G.trans_o = [xL rLo; x4 ro4];                           % transition duct, outer
G.trans_i = [xL rLi; x4 ri4];                           % transition duct, inner
G.dome = [dx rLi; dx rLo];                              % dome at liner nose
G.splitter = [0 rm31; dx rm32];                         % splitter (schematic)
G.swirler = [dx rm32 - rt; dx rm32 + rt];               % primary swirler envelope
G.nozzle = [dx rm32];                                   % fuel nozzle axis
G.sec_pts = [dx + Lpz rLo; dx + Lpz rLi];               % secondary hole rows
G.dil_pts = [dx + Lpz + Lsz rLo; dx + Lpz + Lsz rLi];   % dilution hole rows
G.station_pts = [0 ro31; dx ro32; xL rLo; x4 ro4];      % stations 3.1, 3.2, 3.9, 4
G.x_sec = dx + Lpz;
G.x_dil = dx + Lpz + Lsz;
G.x_end = x4;
G = mm_struct(G);

%% Pack results
M.in = I;
M.res = struct('AR', AR, 'etaReq', etaReq, 'etaD', etaD, 'Cpid', Cpid, 'dx', dx, ...
    'fst', C.fst, 'phi4', phi4, 'dTmax', dTmax, 'phi_pz', phi_pz, 'phi_sz', phi_sz, ...
    'eps_pz', eps_pz, 'Tg', Tg, 'Tm', Tm, 'Tc', Tc, 'epsc', epsc, 'coolType', coolType, ...
    'mu_pz', mu_pz, 'mu_sz', mu_sz, 'mu_c', mu_c, 'mu_dz', mu_dz, ...
    'muA', muA, 'dPq', dPq, 'alpha', alpha, 'HL', HL, 'dPq_min', dPq_min, ...
    'Ur', Ur, 'rho_r', rho_r, 'Vj', Vj, 'Nnoz', Nnoz, 'Asw', Asw, 'rt', rt, ...
    'rh', rh, 'asw', asw, 'Sp', Sp, 'Lpz', Lpz, 'Lsz', Lsz, 'Ldz', Ldz, 'Ltr', Ltr, ...
    'Lliner', Lliner, 'ro32', ro32, 'ri32', ri32, 'rm32', rm32, 'H32', H32, ...
    'ro31', ro31, 'ri31', ri31, 'rm31', rm31, 'ro4', ro4, 'ri4', ri4, 'rLo', rLo, 'rLi', rLi, ...
    'mdot_pz', mdot_pz, 'CD90', CD90, 'dPt_diff', dPt_diff, 'mdot_sw', mdot_sw, ...
    'tauPZ', tauPZ, 'Aj_pz', Aj_pz, 'AL_Aj', AL_Aj, 'AL_Aj_min', AL_Aj_min, 'ts_tm', ts_tm, 'tm_mix', tm_mix, 'ts_pz', ts_pz, ...
    'Nvane', Nvane, 'sigma', sigma, 'rmS', rmS, 'spH', spH, 'spM', spM, 'spT', spT, 'cvane', cvane, ...
    'Lsw', Lsw, 'Hsw', Hsw, 'hpH', hpH, 'hpM', hpM, 'hpT', hpT, 'wthr', wthr);
M.holes_sec = Hs;
M.holes_dil = Hd;
M.kin = kinPZ;
M.geo = G;
M.rep = rep;
end

%% ======================================================================
%%  AFTERBURNER  (Sec. 9.3, example Sec. 9.4.2)
%% ======================================================================
