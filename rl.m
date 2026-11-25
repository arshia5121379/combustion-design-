function L = rl(L, fmt, varargin)
% append one line to a report cell array
L{end+1} = sprintf(fmt, varargin{:});
end

