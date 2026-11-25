function savepng(fh, fname)
% saves the figure as PNG with a side panel listing all inputs / calculated variables
d = 'Combustor_Figures';
if ~exist(d, 'dir')
    mkdir(d);
end
undo = @() [];
try
    drawnow;
    set(fh, 'InvertHardcopy', 'off');
    undo = add_props_panel(fh, fname);
    print(fh, fullfile(d, fname), '-dpng', '-r200');
catch
    warning('Could not save figure %s.png', fname);
end
try
    undo();
catch
end
end

