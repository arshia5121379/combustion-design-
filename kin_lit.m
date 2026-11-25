function lit = kin_lit(S, tau, nstart, thr)
% true if the ignited state survives at residence time tau
S.tau = tau;
n = kin_steady(S, nstart, 40*tau);
lit = (1 - n(1)/S.nF0) > thr;
end

