function [eps_v, T_v] = kin_sweep(S, nstart, taus)
% stationary WSR states versus residence time, continued from the ignited state
eps_v = zeros(numel(taus), 1);
T_v = zeros(numel(taus), 1);
n = nstart;
for i = 1:numel(taus)
    S.tau = taus(i);
    n = kin_steady(S, n, 40*taus(i));
    eps_v(i) = min(max(1 - n(1)/S.nF0, 0), 1);
    T_v(i) = S.Tin + eps_v(i)*S.phi*S.dTmax;
end
end

