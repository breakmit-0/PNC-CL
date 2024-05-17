dimension = 2;
space_length = 40;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.BarycenterGraphBuilder();

%obstacles = testing.Counter_examples();
obstacles = testing.generation_obstacles(dimension,10,5,0,0,space_length,100);
bbx = util.bounding_box(obstacles, 1.25, true);

[P, G, path, corridors, width, dist] = main(obstacles, bbx, src, dest, gBuilder);

disp("Path length: " + dist)
disp("Path width: " + width)
P.plot('color', 'lightblue')
hold on
obstacles.plot('color', 'r')

plot(corridors,'alpha',0.5,'color',[1 1 0],'edgealpha',0)
alt_graph.plot_graph(G);
alt_graph.plot_path(G, src, dest, path);