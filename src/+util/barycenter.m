function [center] = barycenter(polyhedron)
    V = polyhedron.V;

    if height(V) == 1
        center = V;
    else
        center = sum(V) ./ height(V);
    end
end
