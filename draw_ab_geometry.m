function draw_ab_geometry(A)
fig_ab_diffuser(A);          % Fig. 9.27
fig_ab_endviews(A);          % Fig. 9.36
fig_ab_rings(A);             % Fig. 9.E12 (rings only)
fig_ab_full(A);              % complete afterburner side view
fig_ab_diffuser_grid(A);     % diffuser grid search
if ~isempty(A.nomix)
    fig_ab_nomix(A);         % alternate no-mix afterburner
end
end

%% ---------------------------------------------------------------------
%%  Fig. 9.23  air partitioning with the mass flow of every stream
%% ---------------------------------------------------------------------
