function p = nm_phi(K, S, m4, mair, mf)
[~, ~, p] = kin_ab_comp(K, S.phi4, m4, mair, mf, S.RR);
end

