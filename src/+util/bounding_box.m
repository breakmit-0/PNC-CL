function [box] = bounding_box(polyhedra, margin, convex_hull)
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

    box = util.reduction(box, margin);
end

