function dim_v(x, ya, yb, lab, hs)
% vertical dimension line with arrow heads and a rotated label sitting on the line
c = [0.15 0.15 0.15];
ym = 0.5*(ya + yb);
arrow2d(x, ym, x, ya, hs, c, 0.8);
arrow2d(x, ym, x, yb, hs, c, 0.8);
if ~isempty(lab)
    text(x, ym, lab, 'Rotation', 90, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', 'w', 'Margin', 1, 'FontSize', 9);
end
end

