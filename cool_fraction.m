function mu = cool_fraction(e, ctype)
% liner cooling air fraction, Eqs. (9.95)/(9.96), in the form that reproduces
% the book's values (0.644 film, 0.155 effusion at eps = 0.794):
%   film:              mu = (1/6)  * eps/(1-eps) = (1/6)  (Tg-Tm)/(Tm-Tc)
%   transpiration/eff: mu = (1/25) * eps/(1-eps) = (1/25) (Tg-Tm)/(Tm-Tc)
if e <= 0
    mu = 0;
    return
end
if ctype == 1
    mu = e/(6*(1 - e));
else
    mu = e/(25*(1 - e));
end
end

