dimension = 2;
space_length = 30;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
finder = graph.EdgePathFinder();

%obstacles = testing.Counter_examples();
obstacles = testing.generation_obstacles(dimension,10,3,0,0,space_length,100);

[G, path, vertexSet] = main(obstacles, space_length, src, dest, finder);
p = plot(G, ...
    'XData', vertexSet.extract_coords(1), ...
    'YData', vertexSet.extract_coords(2));
highlight(p, path, 'EdgeColor', 'red', 'LineWidth', 3)
hold on 
plot(P,'alpha',0.5)
plot(obstacles)
