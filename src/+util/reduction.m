function out = reduction(polyhedron,homothetie_factor)
% util.reduction The function to reduce a polyhedron by the given homothetie factor around its barycenter[<a href="matlab:web('https://breakmit-0.github.io/util-ppl/')">online docs</a>]
    % 
    %
    % Usage:
    %   P = util.reduction(polyhedron, homothetie_facor)
    %
    % Parameters:
    %   a Polyhedron object, polyhedron 
    %   a scalar, homothetie_factor 
    %
    % Return Values:
    %   P is a Polyhedron object of the same dimension as polyhedron
    %   
    %   P is the reduction of polyhedron around its barycenter by
    %   the given homothetie factor
    %
    % See also util

points = polyhedron.V;
center = util.barycenter(polyhedron);
for i=1:(size(points,1))
    points(i,:) = center + homothetie_factor*(points(i,:)-center);
end
out = Polyhedron(points);
end
