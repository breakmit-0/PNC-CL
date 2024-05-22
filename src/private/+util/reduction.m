function out = reduction(polyhedron,homothetie_factor)
    % util.reduction Changes the size of a Polyhedron around its barycenter
    %
    % Usage:
    %   p = util.reduction(poly, factor)
    %
    % Parameters:
    %   poly is a MPT Polyhedron
    %   factor is a scalar
    %
    % Return Value:
    %   A scaled version of poly is returned, it is not rotated or deformed, and its barycenter is not changed
    %
    % See also util

    points = polyhedron.V;
    center = util.barycenter(polyhedron);
    for i=1:(size(points,1))
        points(i,:) = center + homothetie_factor*(points(i,:)-center);
    end
    out = Polyhedron(points);
end
