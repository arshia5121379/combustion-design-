function undo = add_props_panel(fh, fname)
undo = @() [];
R = prop_store();
if isempty(R)
    return
end
isAB = ~isempty(regexp(fname, '(^ab_|_ab_|E12)', 'once'));
L = prop_lines(R, isAB);
if isempty(L)
    return
end
set(fh, 'Units', 'pixels');
pos = get(fh, 'Position');
nPer = max(20, floor(pos(4)/12));
nCol = ceil(numel(L)/nPer);
extra = nCol*150/pos(3);
axs = [findobj(fh, 'Type', 'axes'); findobj(fh, 'Type', 'colorbar')];
oldP = cell(numel(axs), 1);
for i = 1:numel(axs)
    oldP{i} = get(axs(i), 'Position');
    p = oldP{i};
    set(axs(i), 'Position', [p(1)/(1 + extra), p(2), p(3)/(1 + extra), p(4)]);
end
tb = gobjects(nCol, 1);
for c = 1:nCol
    seg = L((c - 1)*nPer + 1 : min(c*nPer, numel(L)));
    x0 = 1/(1 + extra) + (c - 1)*(extra/(1 + extra))/nCol;
    tb(c) = annotation(fh, 'textbox', [x0, 0.01, (extra/(1 + extra))/nCol, 0.98], 'String', seg, ...
        'FontName', 'Courier', 'FontSize', 6, 'Interpreter', 'none', 'EdgeColor', 'none', ...
        'VerticalAlignment', 'top', 'FitBoxToText', 'off');
end
set(fh, 'PaperUnits', 'inches', 'PaperPositionMode', 'auto');
pp = get(fh, 'PaperPosition');
npp = [0, 0, pp(3)*(1 + extra), pp(4)];
set(fh, 'PaperPositionMode', 'manual', 'PaperSize', [npp(3), npp(4)], 'PaperPosition', npp);
undo = @() restore_panel(fh, axs, oldP, tb);
end

