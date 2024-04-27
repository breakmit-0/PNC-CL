function sp = path(g, start, target, obstacles)
arguments
    g (1, 1) graph;
    start (1, :) double;
    target (1, :) double;
    obstacles (:, 1) Polyhedron, 
end
    nstart = alt_graph.best_start(g, start, obstacles);
    ntarget = alt_graph.best_start(g, target, obstacles);

    if nstart == 0 || ntarget == 0
        error("impossible path finding")
    end

    sp = g.shortestpath(nstart, ntarget);
end
