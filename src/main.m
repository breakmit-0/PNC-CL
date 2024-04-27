function [P, G, vertexSet, path, dist, corridors, d] = main(obstacles, bbx, src, dest, graphBuilder)
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
[G, vertexSet] = graphBuilder.buildGraph(src, dest, obstacles.', P.');
disp("Graph build in " + toc + "s")

tic
[path, dist] = shortestpath(G, vertexSet.getIndex(src), vertexSet.getIndex(dest));
disp("Path found in " + toc + "s")

tic
[corridors, d] = corridor(vertexSet,path,obstacles,100);
disp("Corridors computed in " + toc + "s")

end
