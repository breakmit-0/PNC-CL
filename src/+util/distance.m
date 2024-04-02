% compute the euclidian distance between x and y
% param:
% * x: a column vector
% * y: a column vector of the same dimension as x
function [dist] = distance(x, y)
    dist = sqrt(sum((x - y) .^ 2));
end
