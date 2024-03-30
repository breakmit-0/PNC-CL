% Take a polyhedron with the hyperplane form (with matrix A and vector b)
% and project all faces in R^(d - 1)
% param:
% * A: matrix of size n * n
% * b: column vector of dimension n
function [faces] = projectFacets(A, b)
    % construct associated polyhedron
    P = Polyhedron('A', A, 'b', b);
    P.minHRep();
    % take all facets of P and project them into R^(d - 1)
    faces = arrayfun(@(x) projection(x, 1:(P.Dim - 1)), P.getFacet());
end
