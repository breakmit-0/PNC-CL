function [P, G, path, Corridors, width, path_length] = main(obstacles, bbx, src, dest, graphBuilder)
%% main function sued by most examples

tic
lifting = Lifting.find(obstacles, LiftOptions.linearDefault());
disp("Lift computed in " + toc + "s")

tic
G = lifting.getGraph(graph.EdgeGraphBuilder(), bbx);
P = lifting.getPartition();
disp("Graph build in " + toc + "s")

tic
G = corridors.corridor_width(G, obstacles);
disp("Corridors width computed in " + toc + "s")

tic
G = corridors.edge_weight(G);
disp("Edges weight adjusted in " + toc + "s")

tic
path = graph.path(G, src, dest, obstacles);
disp("Path found in " + toc + "s")

tic
[Corridors, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
disp("Corridors described in " + toc + "s")

tic
path_length = graph.path_length(G, path, src, dest);
disp("Path length computed in " + toc + "s")

end
