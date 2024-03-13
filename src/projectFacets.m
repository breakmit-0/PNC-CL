function [faces] = projectFacets(A, b)
% construct associated polyhedron
P = Polyhedron('A', A, 'b', b);
P.minHRep();
% take all facets of P and project them into R^(d - 1)
faces = arrayfun(@(x) projection(x, 1:(P.Dim - 1)), P.getFacet());
end