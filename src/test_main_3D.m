profile on

dimension = 3;
space_length = 30;
src = [-space_length/2 -space_length/2 -space_length/2];
dest = [space_length/2 space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();

obstacles = testing.generation_obstacles(dimension,50,3,0,0,space_length,100);
%obstacles = util.read_obj("src/+testing/obj/3_cubes.obj").';
bbx = util.bounding_box(obstacles, 1.25, true);

[P, G, path, corridors, d] = main(obstacles, bbx, src, dest, gBuilder);

% disp("Path length: " + dist)
disp("Path width: " + d)
P.plot('alpha', .1, 'color', 'lightblue');
hold on
obstacles.plot('color', 'r');

plot(corridors,'alpha',0.5,'color',[0.5 0.5 0],'edgealpha',0)

alt_graph.plot_graph(G);
alt_graph.plot_path(G, src, dest, path);
