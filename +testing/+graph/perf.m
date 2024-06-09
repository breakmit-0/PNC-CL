global fast_edge


builders = {graph.EdgeGraphBuilder(), graph.BarycenterGraphBuilder()};
dimensions = [3];
obstacleCount = [35 40 50 75 100];
repeat = 10;
repeat_obs = 10;


for dimension = dimensions
    fprintf("Dimension: %d\n", dimension)
    for obs = obstacleCount
        fprintf("Obstacle count: %d\n", obs)
    
        partitions = cell(repeat_obs);
    
        for i = 1:repeat_obs
            failed = true;
            while failed
                obstacles = testing.generation_obstacles(dimension, obs, 2, 0, 0, obs, 100);
                util.write_obj(obstacles, i + ".obj")
                bbx = util.bounding_polyhedron(obstacles, true, 1.25);
                lifting = Lifting.find(obstacles, LiftOptions.linearDefault());

                if lifting.isSuccess
                    partitions{i} = lifting.getPartition(bbx);
                    failed = false;
                end
            end
        end
    
    
        for n = 1:2
            if n == 1
                fprintf("Running slow\n")
                fast_edge = false;
            else
                fprintf("Running fast\n")
                fast_edge = true;
            end
    
            for b = builders
                sum = 0;
                for i = 1:repeat_obs
                    for j = 1:repeat
                        tic
                        b{1}.buildGraph(partitions{i});
                        sum = sum + toc;
                    end
                end
    
                fprintf("Time elapsed: %f\n", sum / (repeat * repeat_obs))
            end
        end
    end
end

fprintf("Finished\n")