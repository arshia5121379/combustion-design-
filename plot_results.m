function plot_results(R)
if isfield(R, 'main')
    plot_main(R.main);
    draw_main_views(R.main);
end
if isfield(R, 'ab')
    plot_ab(R.ab);
    draw_ab_geometry(R.ab);
end
end

