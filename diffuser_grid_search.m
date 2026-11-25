function GD = diffuser_grid_search(etaM, ARd, thHalf)
% Flat-wall diffuser (included angle 2*theta = 9 deg), length ratio 4 < rmm*Lm/(rm1*H1) < 20,
% area ratio 1.5 < AR < 4.  Combined efficiency from Eq. (9.102) with Am/A1 = 1 + 2 tan(theta) Lr
% (Eq. 9.127 inverted).  Section m cannot be larger than the exit, so Am/A1 <= AR.
tn = tan(thHalf*pi/180);
ARv = 1.5:0.05:4;
Lrv = 4:0.02:20;
[ARg, Lg] = meshgrid(ARv, Lrv);
Xg = 1 + 2*tn*Lg;
eta = (etaM*ARg.^2.*(1 - 1./Xg.^2) + 2*(ARg./Xg - 1))./(ARg.^2 - 1);
eta(Xg > ARg) = NaN;
[eg, ig] = max(eta(:));
GD.ARv = ARv; GD.Lrv = Lrv; GD.eta = eta;
GD.eta_g = eg; GD.AR_g = ARg(ig); GD.Lr_g = Lg(ig); GD.x_g = Xg(ig);
GD.valid = (ARd >= 1.5 && ARd <= 4);
Xd = 1 + 2*tn*Lrv;
etad = (etaM*ARd^2*(1 - 1./Xd.^2) + 2*(ARd./Xd - 1))/(ARd^2 - 1);
etad(Xd > ARd) = NaN;
GD.Lr_curve = Lrv; GD.eta_curve = etad;
[eb, ib] = max(etad);
if isnan(eb)
    GD.valid = false;
    eb = NaN; ib = 1;
end
GD.eta_best = eb; GD.Lr_best = Lrv(ib); GD.x_best = Xd(ib);
GD.x_an = etaM*ARd;                                     % Eq. (9.103)
GD.Lr_an = (GD.x_an - 1)/(2*tn);
GD.eta_an = (1 - 2*etaM + (etaM*ARd)^2)/(etaM*(ARd^2 - 1));   % Eq. (9.104)
GD.ARd = ARd; GD.etaM = etaM; GD.theta = thHalf;
end

