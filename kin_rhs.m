function dn = kin_rhs(~, n, S)
% Right-hand side of the WSR species equations, Eq. (9.19), in pseudo-time form:
%   dn_i/dt = (1/rho) sum_j nu_ij R_j - (n_i - n_i*)/tau,   tau = rho V / mdot
%   R_j = k_j prod_k (rho n_k)^(reactant order) * [M]   (third body)
%   k_j = 10^B T^N exp(-Tact/T)  (Table 9.3)
%   T from the linear energy relation Eq. (9.23): T = Tin + eps*phi*dTmax,
%   with eps = 1 - n_fuel/n_fuel,in (fuel conversion).
n = max(n, 0);
eps_ = 1 - n(S.iF)/S.nF0;
eps_ = min(max(eps_, 0), 1);
T = S.Tin + eps_*S.phi*S.dTmax;
rho = S.P/(S.Ru*T*sum(n));                              % ideal gas, mass-specific n
c = rho*n;                                              % concentrations, kmol/m^3
Ctot = S.P/(S.Ru*T);                                    % [M]: total concentration
w = zeros(S.NS, 1);
for j = 1:S.NR
    rj = 10^S.kB(j)*T^S.kN(j)*exp(-S.kTa(j)/T);
    id = S.ridx{j};
    cf = S.rcoef{j};
    for q = 1:numel(id)
        rj = rj*c(id(q))^cf(q);
    end
    if S.tb(j)
        rj = rj*Ctot;
    end
    w = w + S.Nu(:, j)*rj;
end
dn = w/rho - (n - S.nin)/S.tau;
end

