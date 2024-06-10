dimension = 2;
space_length = 50;
src = [-space_length/2 -space_length/2];
dest = [space_length/2 space_length/2];
gBuilder = graph.EdgeGraphBuilder();
n = 10;

widths_linear = zeros(n,1);
lengths_linear = zeros(n,1);
times_linear = zeros(n,1);
widths_convex = zeros(n,1);
lengths_convex = zeros(n,1);
times_convex = zeros(n,1);
widths_cluster = zeros(n,1);
lengths_cluster = zeros(n,1);
times_cluster= zeros(n,1);


i=1;
while i <=  n
    try
        obstacles = testing.generation_obstacles(dimension,20,4,0,0,space_length,100);
        bbx = util.bounding_polyhedron(obstacles, true, 1.25);


        tic
        lifting = Lifting.find(obstacles, LiftOptions.linearDefault());
        G = lifting.getGraph(graph.EdgeGraphBuilder(), bbx);
        P = lifting.getPartition();
        G = corridors.corridor_width(G, obstacles);
        G = corridors.edge_weight(G);
        path = graph.path(G, src, dest, obstacles,P);
        [A, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
        path_length = graph.path_length(G, path, src, dest);
        computation_time = toc;
        widths_linear(i) = width;
        lengths_linear(i) = path_length;
        times_linear(i) = computation_time;

        tic
        lifting = Lifting.find(obstacles, LiftOptions.convexDefault());
        G = lifting.getGraph(graph.EdgeGraphBuilder(), bbx);
        P = lifting.getPartition();
        G = corridors.corridor_width(G, obstacles);
        G = corridors.edge_weight(G);
        path = graph.path(G, src, dest, obstacles,P);
        [A, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
        path_length = graph.path_length(G, path, src, dest);
        computation_time = toc;
        widths_convex(i) = width;
        lengths_convex(i) = path_length;
        times_convex(i) = computation_time;

        % tic
        % lifting = Lifting.find(obstacles, LiftOptions.clusterDefault());
        % G = lifting.getGraph(graph.EdgeGraphBuilder(), bbx);
        % P = lifting.getPartition();
        % G = corridors.corridor_width(G, obstacles);
        % G = corridors.edge_weight(G);
        % path = graph.path(G, src, dest, obstacles,P);
        % [A, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
        % path_length = graph.path_length(G, path, src, dest);
        % computation_time = toc;
        % widths_cluster(i) = width;
        % lengths_cluster(i) = path_length;
        % times_cluster(i) = computation_time;
        fprintf('Success %d \n',i)
        
        i = i+1;
    catch 
        fprintf('The planification failed %d, skipped.\n', i);
    end
end

ax = nexttile;
scatter3(ax, widths_linear, lengths_linear, times_linear,'MarkerFaceColor','r','MarkerEdgeColor','k')
xlabel(ax,'Largeur (en UA)')
ylabel(ax,'Longueur (en UA)')
zlabel(ax,'Temps (en s)')
title(ax,'Performances')
hold on

scatter3(ax,widths_convex, lengths_convex, times_convex, 'MarkerFaceColor','g','MarkerEdgeColor','k')
scatter3(ax,widths_cluster, lengths_cluster, times_cluster, 'MarkerFaceColor','b','MarkerEdgeColor','k')
legend('Linear method', 'Convex method', 'Cluster method')