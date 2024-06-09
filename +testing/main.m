function [P, G, path, Corridors, width, path_length] = main(obstacles, bbx, src, dest, graphBuilder)
% main [<a href="matlab:web('https://breakmit-0.github.io/testing-ppl/')">online docs</a>]
    %
    % Usage:
    %   P = main(obstales, space_length, src, dest, barycenterpath)
    %
    % Parameters:
    %
    %
    % Return Values:
    %  
    %
    %
    %
    % See also lift, project, testing, util, graph


tic
lifting = Lifting.find(obstacles, LiftOptions.linearDefault());
disp("Lift computed in " + toc + "s")

tic
% P = lifting.getPartition(bbx);
% disp("Partition computed in " + toc + "s")
%
% tic
% G = graphBuilder.buildGraph(P);
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
