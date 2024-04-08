dimension = 2;
space_length = 30;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.BarycenterGraphBuilder();

%obstacles = testing.Counter_examples();
obstacles = testing.generation_obstacles(dimension,10,3,0,0,space_length,100);

[P, G, vertexSet, path, dist] = main(obstacles, 1.5 * space_length, src, dest, gBuilder);

disp("Path length: " + dist)
P.plot('color', 'lightblue')
hold on
obstacles.plot('color', 'r')

p = plot(G, ...
    'XData', vertexSet.extractCoords(1), ...
    'YData', vertexSet.extractCoords(2));
highlight(p, path, 'EdgeColor', 'g', 'LineWidth', 2);
