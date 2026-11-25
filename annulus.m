function [H, ro, ri] = annulus(A, rm)
% annulus from area and mean radius, A = 2*pi*rm*H, Eq. (9.122)
H = A/(2*pi*rm);
ro = rm + H/2;
ri = rm - H/2;
end

