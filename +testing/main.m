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
[oa,ob] = lift.find(obstacles);
disp("Lift computed in " + toc + "s")

tic
P = project.fast_partition(oa,ob,bbx);
disp("Partition computed in " + toc + "s")

tic
G = graphBuilder.buildGraph(src, dest, obstacles, P);
disp("Graph build in " + toc + "s")

tic
G = corridors.corridor_width(G, obstacles);
disp("Corridors width computed in " + toc + "s")

tic
G = corridors.edge_weight(G);
disp("Edges weight adjusted in " + toc + "s")

tic
path = alt_graph.path(G, src, dest, obstacles);
disp("Path found in " + toc + "s")

tic
[Corridors, width, path_length] = corridors.corridor_post_processing(G, path, 100);
disp("Corridors described in " + toc + "s")

end
