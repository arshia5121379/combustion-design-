function n = kin_hot_start(K, n)
% small radical seed so the ignited branch can be reached (book: ignition source)
n(sidx(K, 'H')) = n(sidx(K, 'H')) + 1e-7;
n(sidx(K, 'OH')) = n(sidx(K, 'OH')) + 1e-7;
n(sidx(K, 'O')) = n(sidx(K, 'O')) + 1e-8;
end

