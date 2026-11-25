function n = kin_burnout(K, n)
% burn all fuel the local oxygen allows (lean mixture)
C = consts();
a = C.x + C.y/4;
iO2 = sidx(K, 'O2');
b = min(n(1), n(iO2)/a);
n(1) = n(1) - b;
n(iO2) = n(iO2) - a*b;
n(sidx(K, 'CO2')) = n(sidx(K, 'CO2')) + C.x*b;
n(sidx(K, 'H2O')) = n(sidx(K, 'H2O')) + (C.y/2)*b;
end

