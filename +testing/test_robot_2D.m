dimension = 2;
space_length = 40;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();

%obstacles = testing.Counter_examples();
obstacles = testing.generation_obstacles(dimension,10,3,0,0,space_length,100);
robot = testing.generation_obstacles(dimension,1,4,0,0,space_length,100);
bbx = util.bounding_polyhedron(obstacles, 1.25, true);

[P, G, path, corridors, width, dist] = testing.main_robot(obstacles, bbx, src, dest, gBuilder,robot);

disp("Path length: " + dist)
disp("Path width: " + width)
P.plot('color', 'lightblue')
hold on
obstacles.plot('color', 'r')

plot(corridors,'alpha',0.5,'color',[1 1 0],'edgealpha',0)
testing.plot_graph(G);
testing.plot_path(G, src, dest, path);
robot.plot('color', 'g')
