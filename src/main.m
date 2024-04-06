function [P, G, path, vertexSet] = main(obstacles, space_length, src, dest, finder)
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
[G, path, vertexSet] = finder.pathfinder(src, dest, obstacles.', P.');

end
