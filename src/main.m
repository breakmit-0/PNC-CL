function [P, G, vertexSet, path, dist] = main(obstacles, space_length, src, dest, graphBuilder)
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

[oa,ob] = lift.find(obstacles);
epi = project.epigraph(oa,ob,space_length);
P = project.partition(epi);

tic
[G, vertexSet] = graphBuilder.buildGraph(src, dest, obstacles.', P.');
toc

[path, dist] = shortestpath(G, vertexSet.getIndex(src), vertexSet.getIndex(dest));

end
