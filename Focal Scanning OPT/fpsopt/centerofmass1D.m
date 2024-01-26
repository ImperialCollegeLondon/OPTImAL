function x0 = centerofmass1D(vec,varargin)
% Computes the center of mass for a 1D vector,
% x0 = integral{ x f(x) }dx

if ~isvector(vec)
    error('Input must be a 1D vector.');
end


if (nargin > 1)
    threshold = varargin{1};
    vec = (vec > threshold);
end


N = length(vec);
x0 = sum(vec(:).*(1:N)') / sum(vec(:));