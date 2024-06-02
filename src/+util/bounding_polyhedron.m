function [box] = bounding_polyhedron(polyhedra, convex_hull, scale_factor)
    % bounding_polyhedra Compute a polyhedron that contains all polyhedron
    % of polyhedra
    % 
    % Params:
    %      polyhedra: column vector of Polyhedron
    %      convex_hull: if true, compute the convex hull of all polyhedron.
    %          Otherwise, compute the smallest box containing all
    %          polyhedron.
    %      scale_factor: scale the resulting polyhedron by scale_factor
    %
    % Return:
    %      A polyhedron that contains all polyhedron of polyhedra

    if convex_hull
        box = PolyUnion(polyhedra).convexHull();
    else
        minPoint = [];
        maxPoint = [];

        for p = polyhedra.'
            if isempty(minPoint)
                minPoint = min(p.V);
                maxPoint = max(p.V);
            else
                minPoint = min(min(p.V), minPoint);
                maxPoint = max(max(p.V), maxPoint);
            end
        end

        box = Polyhedron('lb', minPoint, 'ub', maxPoint);
    end

    box = util.reduction(box, scale_factor);
end

