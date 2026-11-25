function zone_bracket(xa, xb, y, lab)
plot([xa xb], [y y], 'k-');
plot([xa xa], [y - 0.15, y + 0.15], 'k-');
plot([xb xb], [y - 0.15, y + 0.15], 'k-');
text((xa + xb)/2, y + 0.3, lab, 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom');
end

