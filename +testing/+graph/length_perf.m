builder1 = graph.EdgeGraphBuilder();
builder2 = graph.BarycenterGraphBuilder();
dimensions = [3];
obstacleCount = [5 10 15 20 25 30 35 40 50 75 100];

repeat_obs = 3;

for dimension = dimensions
    fprintf("Dimension: %d\n", dimension)
    for obs = obstacleCount
        fprintf("Obstacle count: %d\n", obs)
    
        partitions = cell(repeat_obs, 1);
    
        sum = 0;
        for i = 1:repeat_obs
            failed = true;
            while failed
                obstacles = testing.generation_obstacles(dimension, obs, 2, 0, 0, obs / 10, 100);
                util.write_obj(obstacles, i + ".obj")
                bbx = util.bounding_polyhedron(obstacles, true, 1.25);
                lifting = Lifting.find(obstacles, LiftOptions.linearDefault());

                if lifting.isSuccess
                    partitions{i} = lifting.getPartition(bbx);
                    failed = false;
                end
            end

            sol = bbx.shoot([1 1 1], repmat(-obs, dimension, 1));
            start = sol.x;

            sol = bbx.shoot([-1 -1 -1], repmat(obs, dimension, 1));
            dest = sol.x;
    
            G1 = builder1.buildGraph(partitions{i});
            G2 = builder2.buildGraph(partitions{i});

            path1 = graph.path(G1, start, dest, obstacles, partitions{i});
            path2 = graph.path(G2, start, dest, obstacles, partitions{i});

            length1 = graph.path_length(G1, path1, start, dest);
            length2 = graph.path_length(G2, path2, start, dest);
            sum = sum + length2 / length1;
        end

        fprintf("Ration %f\n", sum / repeat_obs)
    end
end