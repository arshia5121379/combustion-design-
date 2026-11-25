function restore_panel(fh, axs, oldP, tb)
for i = 1:numel(axs)
    if isgraphics(axs(i))
        set(axs(i), 'Position', oldP{i});
    end
end
delete(tb(isgraphics(tb)));
set(fh, 'PaperPositionMode', 'auto');
end

