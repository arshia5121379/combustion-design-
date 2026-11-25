function draw_main_views(M)
% schematic 2-D figures of the main burner, all drawn from the design results
fig_air_partition(M);        % Fig. 9.23
fig_swirlers(M);             % Fig. 9.E5
fig_jets(M, 1);              % Fig. 9.33
fig_jets(M, 2);              % Fig. 9.34
fig_main_side(M);            % Fig. 9.E7
fig_hole_layout(M);          % Fig. 9.E6
end

