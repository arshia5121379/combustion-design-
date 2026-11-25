function G = ab_growth(r, s)
% shear/mixing-layer growth d(delta)/dx divided by C_delta, Eq. (9.56) as printed
% (r = U2/U1, s = rho2/rho1)
ss = sqrt(s);
G = ((1 - r)/(1 + ss*r))*((1 + ss)/2)* ...
    (1 - ((1 - ss)/(1 + ss))/(1 + 1.29*(1 + r)/(1 - r)));
end

%% ======================================================================
%%  MAIN BURNER  (Sec. 9.2, example Sec. 9.4.1)
%% ======================================================================
