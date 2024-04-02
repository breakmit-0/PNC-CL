disp("BarycenterPathFinder2DTest")

boundingBox = Polyhedron('V', [-5 -5; -5 5; 5 5; 5 -5]);
obstacles = [
    Polyhedron('V', [-0.5 -0.5; -0.5 0.5; 0.5 0.5; 0.5 -0.5]);
    Polyhedron('V', [2 -1; 2 1; 3 2; 3 -2]);
    Polyhedron('V', [-2 -1; -2 1; -3 2; -3 -2]);
    Polyhedron('V', [-1 2; 1 2; 2 3; -2 3]);
    Polyhedron('V', [-1 -2; 1 -2; 2 -3; -2 -3])
];
lift = Polyhedron('V', [-1 -1 0; -1 1 0; 1 1 0; 1 -1 0], 'R', [-1 -1 2; -1 1 2; 1 1 2; 1 -1 2]);
partition = project.projectFacets(lift.A, lift.b);

partition = arrayfun(@(p) p.intersect(boundingBox), partition);

% partition.plot()
hold on
obstacles.plot()

src = [4 0.5];
dest = [0 0.75];

[G, path, vertexSet] = graph.BarycenterPathFinder().pathfinder(src, dest, obstacles, partition);

p = plot(G, ...
    'XData', vertexSet.extractCoords(1), ...
    'YData', vertexSet.extractCoords(2), ...
    'EdgeLabel', G.Edges.Weight);
highlight(p, path, 'EdgeColor', 'g')