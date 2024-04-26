function [box] = bounding_box(polyhedra, margin, convex_hull)
    if convex_hull
        box = util.reduction(PolyUnion(polyhedra).convexHull(), margin);
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
end

