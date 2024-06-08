function best_n = best_start(g, start, target, obstacles)
arguments
    g (1, 1) graph;
    start (1, :) double;
    target (1, :) double;
    obstacles (:, 1) Polyhedron
end
    dist = sqrt (sum((g.Nodes.position - start).^2, 2)) + ...
           sqrt (sum((g.Nodes.position - target).^2, 2));
    [~, I] = sort(dist);

    for i = 1:size(I)
        point = g.Nodes.position(I(i), :);
        sline = Polyhedron('V', [start; point]);

        intersects = false;
        for obs = obstacles.'
            if ~obs.and(sline).isEmptySet()
                intersects = true;
                break;
            end
        end
        
        if ~intersects
            best_n = I(i);
            return
        end
    end

    best_n = -1;
end

