function v = ask(prompt, def)
% numeric input with default (press ENTER to accept the default)
s = input(sprintf('  %s [default %g]: ', prompt, def));
if isempty(s)
    v = def;
else
    v = s;
end
if ~isnumeric(v) || ~isscalar(v) || ~isfinite(v)
    error('Input for "%s" must be a finite numeric value.', prompt);
end
end

