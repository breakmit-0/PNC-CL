clear all;clc;close all;
%% Environment, Lifting, Graph, Path
dimension = 3;
space_length = 30;
src = [-space_length/2 -space_length/2 -space_length/2];
dest = [space_length/2 space_length/2 space_length/2];
gBuilder = graph.BarycenterGraphBuilder();

obstacles = testing.generation_obstacles(dimension,10,0.8,0,0,space_length,100);
bbx = util.bounding_polyhedron(obstacles, true, 1.25);

[P, G, path, Corridors, width, dist] = testing.main(obstacles, bbx, src, dest, gBuilder);
path = graph.constructPath(G, path, src, dest, dist);

disp("Path length: " + dist)
disp("Path width: " + width)
P.plot('alpha', .1, 'color', 'lightblue');
hold on
obstacles.plot('color', 'r','alpha',0.3)

plot(Corridors,'alpha',0.3,'color',[1 1 0],'edgealpha',0)
testing.plot_graph(G);

%% Test MPC code
mpc_input = mpcsettings().default3D;
ctrl = mpc(mpc_input);
[ts, trajectory, controller] = ctrl.relayMPC(path, Corridors, pinv(ctrl.C) * path.V(1,:)');
plot3(trajectory(:,1),trajectory(:,2),trajectory(:,3),'Marker','*','LineStyle','-','color',[0 0 0],'LineWidth',1.5);


