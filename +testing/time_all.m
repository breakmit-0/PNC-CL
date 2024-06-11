

file = fopen("out.txt", "a");

reps = 10;
range = 5:2:60;

% reps = 2;
% range = 5:10:5;



dimension = 2;
space_length = 100;
src = [-space_length -space_length];
dest = [space_length space_length];
gBuilder = graph.EdgeGraphBuilder();


fprintf(file, "nobs lift graph cw ew path cpp pl\n");


for nobs = range
    for r = 1:reps
        %obstacles = testing.Counter_examples();
        obstacles = testing.generation_obstacles(dimension,nobs,3,0,0,space_length,100);
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

        fprintf(file, "%i %i %i %i %i %i %i %i\n", nobs, t);

    end

    fprintf("done with n = %i\n", nobs)
end
