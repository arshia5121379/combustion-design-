function S = kin_struct(K, nin, Tin, P, phi, dTmax)
S.NS = K.NS;
S.NR = K.NR;
S.Nu = K.Nu;
S.ridx = K.ridx;
S.rcoef = K.rcoef;
S.tb = K.tb;
S.kB = K.kB;
S.kN = K.kN;
S.kTa = K.kTa;
S.nin = nin;
S.Tin = Tin;
S.P = P;
S.phi = phi;
S.dTmax = dTmax;
S.iF = 1;
S.nF0 = nin(1);
S.Ru = 8314.46;
S.tau = 1e-5;
end

