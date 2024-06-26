function [center] = barycenter(polyhedron)
    % util.barycenter Returns the barycenter of polyhedron
    %
    % Parameters:
    %     polyhedron: a non empty polyhedron
    %
    % Return value:
    %     center: the barycenter of polyhedron
    %
    % See also util

    V = polyhedron.V;

    if height(V) == 1
        center = V;
    else
        center = sum(V) ./ height(V);
    end
end
