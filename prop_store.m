function out = prop_store(R)
% keeps the design results so every figure can print them
persistent S
if nargin > 0
    S = R;
end
out = S;
end

