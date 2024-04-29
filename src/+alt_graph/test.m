
dim = 2;
space_size = 200;

obs = testing.generation_obstacles(dim, 50, 5, 0.1, 0.1, space_size);
obs = obs([obs.Dim] > 0);

fprintf("\n--- FINDING LIFT ---\n");
fprintf("number of obstacles = %d\n\n", size(obs, 1));

[oa, ob, cvx] = lift.find_iter(obs, 5);

if ~(cvx > 0) 
    error("failed to find a convex lifting");
end

tic
fprintf("\n--- PROJECTION ---\n");

box = util.bounding_box(obs, 1.2, true);
part = project.fast_partition(oa, ob, box);

dt = toc;
fprintf("took %.2f s\n", dt);

tic
fprintf("\n--- GENERATING EDGES ---\n");

r = alt_graph.find_edges(part);

dt = toc;
fprintf("took %.2f s\n", dt);
fprintf("generated %d edges\n", size(r, 1));

tic
fprintf("\n--- GENERATING GRAPH ---\n");

g = alt_graph.gen_graph(r);

dt = toc;
fprintf("took %.2f s\n", dt);
fprintf("graph has %.0f nodes and %.0f edges\n", size(g.Nodes, 1), size(g.Edges, 1));


tic
fprintf("\n--- FINDING PATH ---\n");

start = -space_size*ones(1, dim);
target = space_size*ones(1, dim);
p = alt_graph.path(g, start, target, obs);

dt = toc;
fprintf("took %.2f s\n", dt);

alpha = 0.1;
if dim ~= 2
    alpha = 0.001;
end

plot(part, 'alpha', alpha);
hold on;
alt_graph.plot_graph(g);
hold on;
alt_graph.plot_path(g, start, target, p);
hold on;
plot(obs);