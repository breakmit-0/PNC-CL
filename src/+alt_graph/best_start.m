function best_n = best_start(g, start, obstacles)
arguments
    g (1, 1) graph;
    start (1, :) double;
    obstacles (:, 1) Polyhedron, 
end
    N = size(g.Nodes.position, 1);


    d2 = sum((g.Nodes.position - start).^2, 2);

    best_n = 0;
    best_d2 = NaN;
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
        
        if ~intersects && ~(d2(i) >= best_d2)
            best_n = i;
            best_d2 = d2(i);
        end
    end
end


