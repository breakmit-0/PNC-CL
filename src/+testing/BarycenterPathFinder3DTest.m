disp("BarycenterPathFinder3DTest")

hold on

obstacles = util.read_obj("src/+testing/EdgePathFinder3DTest_obstacles.obj", true);
obstacles.plot()

partition = util.read_obj("src/+testing/EdgePathFinder3DTest_partition.obj", false);
% partition.plot('FaceColor','b','FaceAlpha',.3,'EdgeAlpha',.3)
% obstacles.plot()


src = [4.5 1 0];
dest = [-1.5 -0 0];

[G, path, vertexSet] = graph.BarycenterPathFinder().pathfinder(src, dest, obstacles, partition);

p = plot(G, ...
    'XData', vertexSet.extract_coords(1), ...
    'YData', vertexSet.extract_coords(2), ...
    'ZData', vertexSet.extract_coords(3), ...
    'EdgeLabel', G.Edges.Weight);
highlight(p, path, 'EdgeColor', 'g')