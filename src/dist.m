function [dist] = dist(x, y)
dist = sqrt(sum((x - y) .^ 2));
end

