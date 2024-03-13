function [edges] = polyhedronToEdges(polyhedron)
polyhedron.minHRep();
if polyhedron.Dim == 2
    edges = polyhedron.getFacet();
else
    edges = arrayfun(@polyhedronToEdges, faces);
    edges = reshape(edges, [width(edges) * height(edges)]);
end
end

