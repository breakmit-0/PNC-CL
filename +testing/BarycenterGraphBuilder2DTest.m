disp("BarycenterGraphBuilder2DTest")

boundingBox = Polyhedron('V', [-5 -5; -5 5; 5 5; 5 -5]);
obstacles = [
    Polyhedron('V', [-0.5 -0.5; -0.5 0.5; 0.5 0.5; 0.5 -0.5])
    Polyhedron('V', [2 -1; 2 1; 3 2; 3 -2])
    Polyhedron('V', [-2 -1; -2 1; -3 2; -3 -2])
    Polyhedron('V', [-1 2; 1 2; 2 3; -2 3])
    Polyhedron('V', [-1 -2; 1 -2; 2 -3; -2 -3])
];
partition = [
    Polyhedron('V', [-1 -1; 1 1; -1 1; 1 -1])
    Polyhedron('V', [ 1  1;  1 -1], 'R', [ 1  1;  1 -1])
    Polyhedron('V', [ 1 -1; -1 -1], 'R', [ 1 -1; -1 -1])
    Polyhedron('V', [-1 -1; -1  1], 'R', [-1 -1; -1  1])
    Polyhedron('V', [-1  1;  1  1], 'R', [-1  1;  1  1])
];
partition = arrayfun(@(p) p.intersect(boundingBox), partition);

src = [4 0.5];
dest = [0 0.75];

[G, vertexSet] = graph.BarycenterGraphBuilder().buildGraph(src, dest, obstacles.', partition.');

partition.plot('color', 'lightblue')
hold on
obstacles.plot('color', 'r')

p = plot(G, ...
    'XData', vertexSet.extractCoords(1), ...
    'YData', vertexSet.extractCoords(2), ...
    'EdgeLabel', G.Edges.Weight);
