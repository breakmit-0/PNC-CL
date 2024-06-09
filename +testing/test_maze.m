clear all;
clc;
close all;

dimension = 2;
space_length = 100;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();

%obstacles = testing.Counter_examples();
% obstacles = testing.generation_obstacles(dimension,60,3,0,0,space_length,100);
obstacles = testing.maze;
bbx = util.bounding_polyhedron(obstacles, true, 1.25);

[P, G, path, corridors, width, dist] = testing.main(obstacles, bbx, src, dest, gBuilder);

disp("Path length: " + dist)
disp("Path width: " + width)
P.plot('color', 'lightblue')
hold on
obstacles.plot('color', 'r')

% plot(corridors,'alpha',0.5,'color',[1 1 0],'edgealpha',0)
% testing.plot_graph(G);
% testing.plot_path(G, src, dest, path);


