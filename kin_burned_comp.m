function n = kin_burned_comp(K, phi)
% complete-combustion products of a lean mixture, Eq. (9.20) basis
C = consts();
[n, mass] = kin_fresh_comp(K, phi);
a = C.x + C.y/4;
airmol = a/(0.21*phi);
n(1) = 0;
n(sidx(K, 'O2')) = (airmol*0.21 - a)/mass;
n(sidx(K, 'CO2')) = C.x/mass;
n(sidx(K, 'H2O')) = (C.y/2)/mass;
n(sidx(K, 'N2')) = airmol*0.79/mass;
end

