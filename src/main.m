function [P, G, path, corridors, d] = main(obstacles, bbx, src, dest, graphBuilder)
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
G = graphBuilder.buildGraph(P);
disp("Graph build in " + toc + "s")

tic
path = alt_graph.path(G, src, dest, obstacles);
disp("Path found in " + toc + "s")

tic
[corridors, d] = corridor(G.Nodes.position, path, obstacles, 100);
disp("Corridors computed in " + toc + "s")

end
