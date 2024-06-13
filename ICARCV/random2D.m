clear all;clc;close all;
addpath('../src/')

%% Environment, Lifting, Graph, Path
dimension = 2;
space_length = 10;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();

P   = util.randEnv(dimension,10,0.8,0,0,space_length,100);
bbx = util.bounding_polyhedron(P, false, 1.25);

[X, G, path, PI, width, dist] = main(P, bbx, src, dest, gBuilder);
path = graph.constructPath(G, path, src, dest, dist);

disp("Path length: " + dist)
disp("Path width: " + width)

%% Test MPC code
mpc_input = mpcsettings().default2D();
ctrl = mpc(mpc_input);
[ts, trajectory, controller] = ctrl.relayMPC(path, PI, pinv(ctrl.C) * path.V(1,:)');

%% Plot Cluttered Environment
f = plotSpace(X, P, G, PI, trajectory);
exportgraphics(f, "figures/random2D.pdf" ,'ContentType','vector')
