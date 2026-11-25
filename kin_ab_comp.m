function [nin, nstart, phiF] = kin_ab_comp(K, phi4, m4, mair, mfAB, RR)
% afterburner WSR inlet: station-4 products + cooling/bypass air + fuel, with
% recirculation ratio RR (Sec. 9.3.2.5, Sec. 9.4.2.3)
C = consts();
n4 = kin_burned_comp(K, phi4);                          % station-4 products per kg
nair = zeros(K.NS, 1);
nair(sidx(K, 'O2')) = 0.21/C.Mair;
nair(sidx(K, 'N2')) = 0.79/C.Mair;
napp = (m4*n4 + mair*nair)/(m4 + mair);                 % approach gas per kg
f = mfAB/(m4 + mair + mfAB);                            % afterburner fuel mass fraction
nfresh = (1 - f)*napp;
nfresh(1) = f/C.MF;
phiF = nfresh(1)*(C.x + C.y/4)/nfresh(sidx(K, 'O2'));   % local equivalence ratio, Eq. (9.4)
nhot = kin_burnout(K, nfresh);                          % fully burned fresh mixture
nin = (nfresh + RR*nhot)/(1 + RR);                      % recirculated gases
nstart = kin_hot_start(K, kin_burnout(K, nin));         % ignited starting state
end

