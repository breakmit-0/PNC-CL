function sp = path_robot(g, start, target, obstacles, partition, robot)
arguments
    g (1, 1) graph;
    start (1, :) double;
    target (1, :) double;
    obstacles (:, 1) Polyhedron;
    partition (:, 1) Polyhedron
    robot (1, 1) Polyhedron;
end
    % PATH Compute the shortest path in a graph. It is only useful if the
    % start and target points aren't in the graph.
    %
    % This function use graph.best_start to find how to link start and
    % target point to the graph.
    %
    % Params:
    %     g: a graph
    %     start: start point, can be outside the graph
    %     target: target point, can be outside the graph
    %     obstacles: column vector of Polyhedron
    %
    % Returns:
    %     sp: a line vector of integer indicating a path in g. Start and
    %     target point aren't included inside this vector as they aren't
    %     part of g.

    nstart = graph.best_start_robot(g, start, target, obstacles, partition, robot);
    ntarget = graph.best_start_robot(g, target, start, obstacles, partition, robot);

    if nstart <= 0 || ntarget <= 0
        error("Impossible path finding. Start or dest in inside one obstacle")
    end

    sp = g.shortestpath(nstart, ntarget);
end