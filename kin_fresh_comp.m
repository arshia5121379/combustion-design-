function [n, mass] = kin_fresh_comp(K, phi)
% fresh fuel + air, mass-specific mole numbers n (kmol/kg); basis 1 kmol fuel
C = consts();
a = C.x + C.y/4;                                        % O2 per fuel molecule, Eq. (9.1)
airmol = a/(0.21*phi);                                  % kmol air per kmol fuel, Eq. (9.4)
mass = C.MF + airmol*C.Mair;                            % kg mixture per kmol fuel
n = zeros(K.NS, 1);
n(1) = 1/mass;
n(sidx(K, 'O2')) = airmol*0.21/mass;
n(sidx(K, 'N2')) = airmol*0.79/mass;
end

