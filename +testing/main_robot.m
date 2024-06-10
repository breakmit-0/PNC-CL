function [P, G, path, Corridors, width, path_length] = main_robot(obstacles, bbx, src, dest, graphBuilder, robot)
% main [<a href="matlab:web('https://breakmit-0.github.io/testing-ppl/')">online docs</a>]
    %
    % Usage:
    %   P = main(obstales, obstacles, bbx, src, dest, graphBuilder, robot)
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
G = lifting.getGraph(graphBuilder, bbx);
P = lifting.getPartition();
disp("Graph build in " + toc + "s")

tic
G = corridors.corridor_width(G, obstacles);
disp("Corridors width computed in " + toc + "s")

tic
G = corridors.edge_weight_robot(G,robot);
disp("Edges weight adjusted in " + toc + "s")

tic
path = graph.path_robot(G, src, dest, obstacles, robot);
disp("Path found in " + toc + "s")

tic
[Corridors, width] = corridors.corridor_post_processing(G, path, src, dest, obstacles, 100);
disp("Corridors described in " + toc + "s")

tic
path_length = graph.path_length(G, path, src, dest);
disp("Path length computed in " + toc + "s")
end
