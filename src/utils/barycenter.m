function [center] = barycenter(polyhedron)
    V = polyhedron.V;
    center = sum(V) ./ height(V);
end

