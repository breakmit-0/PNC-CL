disp("BarycenterGraphBuilder3DTest")

obstacles = util.read_obj("src/+testing/obj/obstacles_1.obj");
partition = util.read_obj("src/+testing/obj/partition_1.obj");

src = [4.5 1 0];
dest = [-1.5 -0 0];

[G, vertexSet] = graph.BarycenterGraphBuilder().buildGraph(src, dest, obstacles, partition);

obstacles.plot('color', 'r');
hold on
partition.plot('alpha', .1, 'color', 'lightblue');
plot(G, ...
    'XData', vertexSet.extractCoords(1), ...
    'YData', vertexSet.extractCoords(2), ...
    'ZData', vertexSet.extractCoords(3), ...
    'EdgeLabel', G.Edges.Weight);
