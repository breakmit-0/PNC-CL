function sp = path(g, start, target, obstacles)
arguments
    g (1, 1) graph;
    start (1, :) double;
    target (1, :) double;
    obstacles (:, 1) Polyhedron
end
    nstart = alt_graph.best_start(g, start, target, obstacles);
    ntarget = alt_graph.best_start(g, target, start, obstacles);

    if nstart <= 0 || ntarget <= 0
        error("Impossible path finding. Start or dest in inside one obstacle")
    end

    sp = g.shortestpath(nstart, ntarget);
end
