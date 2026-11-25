function n = kin_steady(S, n0, tend)
% integrate the WSR equations in pseudo-time to a stationary state
opts = odeset('RelTol', 1e-6, 'AbsTol', 1e-14);
[~, y] = ode15s(@(t, nn) kin_rhs(t, nn, S), [0 tend], n0, opts);
n = y(end, :)';
end

