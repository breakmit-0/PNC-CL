clear all;clc;close all;
addpath('../src/')

%% Environment, Lifting, Graph, Path
dimension = 2;
space_length = 20;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();

P   = util.randEnv(dimension,10,0.8,0,0,space_length,100);
bbx = util.bounding_polyhedron(P, false, 1.25);

[X, G, path, PI, width, dist] = main(P, bbx, src, dest, gBuilder);
path = graph.constructPath(G, path, src, dest, dist);

disp("Path length: " + dist)
disp("Path width: " + width)

f1 = plotSpace(X, P, G, PI, []);
exportgraphics(f1, "figures/hullExample1.pdf" ,'ContentType','vector')


%%
bbx = util.bounding_polyhedron(P, true, 1.25);

[X, G, path, PI, width, dist] = main(P, bbx, src, dest, gBuilder);
path = graph.constructPath(G, path, src, dest, dist);

disp("Path length: " + dist)
disp("Path width: " + width)

f2 = plotSpace(X, P, G, PI, []);
exportgraphics(f2, "figures/hullExample2.pdf" ,'ContentType','vector')
