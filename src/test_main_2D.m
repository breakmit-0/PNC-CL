dimension = 2;
space_length = 30;
src = [0 0];
dest = [space_length space_length];
finder = graph.EdgePathFinder();

%obstacles = testing.Counter_examples();
obstacles = testing.generation_obstacles(dimension,10,3,0,0,space_length,100);

[G, path, vertexSet] = main(obstacles, space_length, src, dest, finder);
p = plot(G, ...
    'XData', vertexSet.extract_coords(1), ...
    'YData', vertexSet.extract_coords(2));
highlight(p, path, 'EdgeColor', 'red', 'LineWidth', 3)
hold on 
plot(obstacles)