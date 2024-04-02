disp("BarycenterPathFinder3DTest")

hold on

obstacles = util.readObj("src/+testing/EdgePathFinder3DTest_obstacles.obj", true);
obstacles.plot()

partition = util.readObj("src/+testing/EdgePathFinder3DTest_partition.obj", false);
% partition.plot('FaceColor','b','FaceAlpha',.3,'EdgeAlpha',.3)
% obstacles.plot()


src = [4.5 1 0];
dest = [-1.5 -0 0];

[G, path, vertexSet] = graph.BarycenterPathFinder().pathfinder(src, dest, obstacles, partition);

p = plot(G, ...
    'XData', vertexSet.extractCoords(1), ...
    'YData', vertexSet.extractCoords(2), ...
    'ZData', vertexSet.extractCoords(3), ...
    'EdgeLabel', G.Edges.Weight);
highlight(p, path, 'EdgeColor', 'g')