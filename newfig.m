function fh = newfig(name, w, h)
% new figure with a fixed size; windows are staggered so they never sit on top of each other
persistent n
if isempty(n)
    n = 0;
end
n = n + 1;
sc = get(0, 'ScreenSize');
w = min(w, sc(3) - 60);
h = min(h, sc(4) - 120);
off = 28*mod(n - 1, 8);
fh = figure('Name', name, 'NumberTitle', 'off', 'Color', 'w', ...
    'Position', [30 + off, max(40, sc(4) - h - 90 - off), w, h]);
set(fh, 'DefaultAxesFontSize', 10);
end

