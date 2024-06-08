function [times] = timeit(nobs, space_size, dim)
arguments
    nobs (1, 1) int32;
    space_size (1, 1) double = 100;
    dim (1, 1) int32 = 2;
end
    times = [];

    gentime = tic();
    obs = testing.generation_obstacles(dim, nobs, 2, 0.1, 0.1, space_size);
    obs = obs([obs.Dim] > 0);
    times(end+1) = toc(gentime);

    ltime = tic();
    [oa, ob, cvx] = lift.find(obs);
    times(end+1) = toc(ltime);

    if ~(cvx > 0) 
        error("failed to find a convex lifting");
    end

    ptime = tic;
    box = util.bounding_box(obs, 1.2, true);
    part = project.fast_partition(oa, ob, box);
    times(end+1) = toc(ptime);

    edgetime = tic();
    r = alt_graph.flatten_facets(part);
    times(end+1) = toc(edgetime);

    graphtime = tic();
    g = alt_graph.gen_graph(r);
    times(end+1) = toc(graphtime);

    pathtime = tic();
    start = -space_size*ones(1, dim);
    target = space_size*ones(1, dim);
    p = alt_graph.path(g, start, target, obs);
    times(end+1) = toc(pathtime);
end
