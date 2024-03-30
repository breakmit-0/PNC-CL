function out = reduction(polyhedron,homothetie_factor)

points = polyhedron.V;
center = barycenter(polyhedron);
for i=1:(size(points,1))
    points(i,:) = center + homothetie_factor*(points(i,:)-center);
end
out = Polyhedron(points);
end