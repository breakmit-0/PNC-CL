function n = best_start(g, start, obstacles)
arguments
    g (1, 1) graph;
    start (1, :) double;
    obstacles (:, 1) Polyhedron, 
end
    N = size(g.Nodes.position, 1);

    % dot product each row with the direction
    keys = sum(abs(g.Nodes.position - start), 2); 


    sorter = sortrows([keys (1:N)'], 1); 
    n = 0;

    % find the non crossing path best aligned with the goal
    for i = 1:N
        sline = Polyhedron('V', [start; g.Nodes.position(i, :)]);
        intersects = false;

        for obs = 1:size(obstacles, 1)
            if ~obstacles(obs).and(sline).isEmptySet()
                intersects = true;
                break;
            end
        end
        
        if ~intersects
            n = sorter(i,2);
            return;
        end
    end
end


