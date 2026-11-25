function out = kin_design(K, nin, nstart, Tin, P, phi, dTmax, tau, thr)
% WSR stationary state at the design residence time, plus the blowout time
S = kin_struct(K, nin, Tin, P, phi, dTmax);
S.tau = tau;
n = kin_steady(S, nstart, 40*tau);
out.tau = tau;
out.eps = min(max(1 - n(1)/S.nF0, 0), 1);
out.T = Tin + out.eps*phi*dTmax;
out.x = n/sum(n);                                       % mole fractions
out.names = K.sp;
out.tBO = kin_blowout(S, nstart, thr);
end

%% ======================================================================
%%  OUTPUT: geometry, figures, files
%% ======================================================================
