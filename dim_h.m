function dim_h(xa, xb, y, lab, hs)
% horizontal dimension line with arrow heads and a label sitting on the line
c = [0.15 0.15 0.15];
xm = 0.5*(xa + xb);
arrow2d(xm, y, xa, y, hs, c, 0.8);
arrow2d(xm, y, xb, y, hs, c, 0.8);
if ~isempty(lab)
    text(xm, y, lab, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'middle', ...
        'BackgroundColor', 'w', 'Margin', 1, 'FontSize', 9);
end
end

