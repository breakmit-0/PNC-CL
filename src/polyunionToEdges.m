function [edges] = polyunionToEdges(polyhedra)
edges = [];
for polyhedron = polyhedra.'
    edges = [polyhedronToEdges(polyhedron); edges];
end
edges = unique(edges);
end

