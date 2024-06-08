dimension = 2;
space_length = 25;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();
gBuilder.parallel = true;

%obstacles = testing.Counter_examples();
obstacles = testing.generation_obstacles(dimension,10,1,0,0,space_length,100);
bbx = util.bounding_polyhedron(obstacles, 1.25, true);

[P, G, path, corridors, d] = testing.main(obstacles, bbx, src, dest, gBuilder);

%%

disp("Path width: " + d)
P.plot('color', 'lightblue')
hold on
obstacles.plot('color', 'r')

plot(corridors,'alpha',0.2,'color',[0.5 0.5 0],'edgealpha',0)
alt_graph.plot_graph(G);


%% Test new MPC code

mpc_input = mpcsettings();

dt = 0.2;
A = [1  0 dt  0;
     0  1  0 dt;
     0  0  1  0;
     0  0  0  1];
B = [0 0;0 0;1 0;0 1]*dt;
C = [1 0 0 0;
     0 1 0 0]; 
D = 0;

Q = diag([2,2,10,10]);
R = eye(2)*0.1;

mpc_input.A = A;
mpc_input.B = B;
mpc_input.C = C;
mpc_input.D = D;
mpc_input.Q = Q;
mpc_input.R = R;

mpc_input.terminal_cost_use = 1;
mpc_input.terminal_set_use = 1;
mpc_input.terminal_set_fast = 1;

mpc_input.u.min = [-2,-2]*2;
mpc_input.u.max =  [2,2]*2;

mpc_input.x.set = Polyhedron;
mpc_input.Np = 12;


ctrl = mpc(mpc_input);

pathS = struct('V',table2array(G.Nodes(path,:)));
x0 = pinv(ctrl.C) * pathS.V(1,:)';
[ts, trajectory, controller] = ctrl.relayMPC(pathS, corridors, x0);
%%
plot(trajectory(:,1),trajectory(:,2),'Marker','*','LineStyle','-','color',[0 0 0],'LineWidth',1.5);

