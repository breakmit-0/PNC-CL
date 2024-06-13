clear all;clc;close all;

addpath('../src')
%%
reps = 5;
range = 5:5:75;

dimension = 2;
space_length = 100;
src = [-space_length -space_length];
dest = [space_length space_length];
gBuilder = graph.EdgeGraphBuilder();

fprintf("nobs lift graph cw ew path cpp pl\n");
t = zeros(7,1);
table = [];
for nobs = range
    tsum = zeros(7,1);
    for r = 1:reps
        %obstacles = testing.Counter_examples();
        obstacles = util.randEnv(dimension,nobs,0.1,0,0,space_length,1000);
        bbx = util.bounding_polyhedron(obstacles, true, 1.25);

        tic
        lifting = Lifting.find(obstacles, LiftOptions.linearDefault());
        t(1) = toc;

        tic
        G = lifting.getGraph(graph.EdgeGraphBuilder(), bbx);
        P = lifting.getPartition();
        t(2) = toc;

        tic
        G = corridors.corridor_width(G, obstacles);
        t(3) = toc;

        tic
        G = corridors.edge_weight(G);
        t(4) = toc;

        tic
        path = graph.path(G, src, dest, obstacles, P);
        t(5) = toc;

        tic
        [Corridors, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
        t(6) = toc;

        tic
        path_length = graph.path_length(G, path, src, dest);
        t(7) = toc;

        tsum = tsum + t;
        
    end
    table = [table, tsum ./ reps];
    fprintf("%i %i %i %i %i %i %i %i\n", nobs, tsum);
end
fprintf("done with n = %i\n", nobs)
%%

graph_index = [2,3,4,6];
figure()
colororder("meadow")
hold on
plot(range,table(1,:),'LineWidth',1.5,'Marker','o')
plot(range,table(2,:),'LineWidth',1.5,'Marker','square')
plot(range,table(6,:)+table(3,:)+table(4,:),'LineWidth',1.5,'Marker','diamond')
plot(range,table(5,:),'LineWidth',1.5,'Marker','^')
grid on
xlabel('number of obstacles')
ylabel('time [sec]')
legend('Lifting', 'Graph','Corridor', 'Djkstra')
