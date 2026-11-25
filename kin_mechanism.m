function K = kin_mechanism()
% Table 9.3, Kollrack 30-step pyrolysis mechanism for C12H23 (Ref. 5).
% Each row: reaction, B (log10 of pre-exponential), N (temperature exponent),
% Tact (activation temperature), with k = 10^B * T^N * exp(-Tact/T) in SI
% units (kmol, m^3, K, s). M = third body. Only forward rates are tabulated.
K.sp = {'C12H23','O2','OH','C2H4','O','C2H3','H2','H','H2O','CO','CO2', ...
        'HO2','CH3','CH2O','HCO','N2','NO','N','NO2','C2H2','CH4'};
rx = {
 'C12H23 + O2 => 5 C2H4 + C2H3 + O2',   4.48,  1.5,  7900
 'C12H23 + OH => 6 C2H4 + O',           7.30,  1.0,  4500
 'C2H4 + H => C2H3 + H2',               10.48, 0.0,  9500
 'H + H + M => H2 + M',                 12.30, -1.0, 0
 'O + O + M => O2 + M',                 11.00, -1.0, 0
 'H + OH + M => H2O + M',               13.85, -1.0, 0
 'H + O2 => OH + O',                    11.35, 0.0,  8400
 'O + H2 => OH + H',                    10.24, 0.0,  4730
 'CO + OH => CO2 + H',                  -14.75, 7.0, -7000
 'H + H2O => OH + H2',                  10.92, 0.0,  10050
 'CH3 + O2 => CH2O + OH',               9.00,  0.0,  4000
 'HO2 + M => H + O2 + M',               12.32, 0.0,  23000
 'HO2 + H => OH + OH',                  9.89,  0.0,  950
 'CH2O + OH => H2O + HCO',              10.90, 0.0,  2120
 'O + H2O => OH + OH',                  10.76, 0.0,  9000
 'N2 + O => NO + N',                    9.00,  0.0,  25000
 'N + O2 => NO + O',                    5.00,  1.0,  2000
 'N + OH => NO + H',                    9.00,  0.0,  0
 'HCO + O2 => HO2 + CO',                10.48, 0.0,  7000
 'HCO + OH => H2O + CO',                10.30, 0.0,  0
 'C2H4 + OH => C2H3 + H2O',             9.78,  0.0,  1750
 'CH2O + HO2 => HCO + OH + OH',         9.00,  0.0,  4500
 'C2H2 + HO2 => HCO + CH2O',            9.30,  0.0,  5500
 'C2H3 + O2 => C2H2 + HO2',             9.23,  0.0,  5000
 'NO + HO2 => NO2 + OH',                3.00,  1.0,  0
 'C2H4 + O => CH3 + HCO',               9.93,  0.0,  1500
 'C2H4 + HO2 => CH3 + HCO + OH',        9.90,  0.0,  5000
 'H2 + CH3 => CH4 + H',                 7.00,  -1.5, 7140
 'C2H2 + OH => CH3 + CO',               8.20,  0.0,  2500
 'CH3 + O => CH2O + H',                 11.11, 0.0,  1000};
NR = size(rx, 1);
NS = numel(K.sp);
K.NR = NR;
K.NS = NS;
K.Nu = zeros(NS, NR);                                   % net stoichiometry nu''-nu'
K.ridx = cell(NR, 1);
K.rcoef = cell(NR, 1);
K.tb = false(NR, 1);
K.kB = zeros(NR, 1);
K.kN = zeros(NR, 1);
K.kTa = zeros(NR, 1);
for j = 1:NR
    parts = strsplit(rx{j, 1}, '=>');
    [ri, rc, hasM] = parse_side(parts{1}, K.sp);
    [pidx, pc, ~] = parse_side(parts{2}, K.sp);
    K.ridx{j} = ri;
    K.rcoef{j} = rc;
    K.tb(j) = hasM;
    for q = 1:numel(ri)
        K.Nu(ri(q), j) = K.Nu(ri(q), j) - rc(q);
    end
    for q = 1:numel(pidx)
        K.Nu(pidx(q), j) = K.Nu(pidx(q), j) + pc(q);
    end
    K.kB(j) = rx{j, 2};
    K.kN(j) = rx{j, 3};
    K.kTa(j) = rx{j, 4};
end
end

