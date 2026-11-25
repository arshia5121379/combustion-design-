function [U, rho, T, P] = station_flow(Pt, Tt, M, g, Rg)
% static state and velocity from total state and Mach number
T = Tt/(1 + (g - 1)/2*M^2);
P = Pt/(1 + (g - 1)/2*M^2)^(g/(g - 1));
U = M*sqrt(g*Rg*T);
rho = P/(Rg*T);
end

