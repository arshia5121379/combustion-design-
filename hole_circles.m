function [X, Y] = hole_circles(xc, ys, rad)
% NaN-separated circles of radius rad at (xc, ys(k))
t = linspace(0, 2*pi, 33);
X = []; Y = [];
for k = 1:numel(ys)
    X = [X, xc + rad*cos(t), NaN];       %#ok<AGROW>
    Y = [Y, ys(k) + rad*sin(t), NaN];    %#ok<AGROW>
end
end

%% ======================================================================
%%  OUTPUT: figures
%% ======================================================================
