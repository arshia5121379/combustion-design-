function J = jet_holes(qj, qA, qL, HL, k, mdot_s, rho, Vj, CD, Nnoz)
% secondary (k = 4) or dilution (k = 3) air jets, Eqs. (9.107)-(9.119)
s2 = 1 - qA/qj;
if s2 <= 0
    error('Annulus dynamic pressure exceeds the jet dynamic pressure.');
end
sinth = sqrt(s2);                              % Eq. (9.115)
YdJ = 1.15*sqrt(qj/qL)*sinth;                  % Eq. (9.107) with sin(theta), Eq. (9.44)
dj = (HL/k)/YdJ;                               % Eq. (9.112)/(9.117): target penetration HL/k
Aj = pi*dj^2/4;                                % vena-contracta area
Ntot = mdot_s/(rho*Vj*Aj);                     % Eq. (9.113)/(9.118)
dh = dj/(sqrt(CD)*sinth);                      % Eq. (9.114): CD(theta) = CD90 sin^2(theta)
J.qA = qA; J.qL = qL; J.sinth = sinth; J.theta = asin(sinth);
J.YdJ = YdJ; J.dj = dj; J.dh = dh; J.Ntot = Ntot; J.Nper = Ntot/Nnoz;
end

