dimension = 3;
space_length = 30;
src = [-space_length/2 -space_length/2 -space_length/2];
dest = [space_length/2 space_length/2 space_length/2];
gBuilder = graph.BarycenterGraphBuilder();

obstacles = testing.generation_obstacles(dimension,10,5,0,0,space_length,100);
robot = testing.generation_obstacles(dimension,1,3,0,0,0,100) + src';
%obstacles = util.read_obj("src/+testing/obj/3_cubes.obj").';
bbx = util.bounding_polyhedron(obstacles, false, 1.25);

[P, G, path, Corridors, width, dist] = testing.main_robot(obstacles, bbx, src, dest, gBuilder, robot);
robot_radius = util.radius(robot);

disp("Path length: " + dist)
disp("Path width: " + width)
disp("Robot radius; " + robot_radius)
disp("Warning : robot plotted at position src, it's not an obstacle!")
P.plot('alpha', .1, 'color', 'lightblue');
hold on
obstacles.plot('color', 'r')

plot(Corridors,'alpha',0.5,'color',[1 1 0],'edgealpha',0)
testing.plot_graph(G);
testing.plot_path(G, src, dest, path);
robot.plot('color', 'g', 'alpha', 0.5,'edgealpha',0.5)
