function [P, min_width] = corridor_post_processing(G, path, start, target, obstacles, n)
% corridor_post_processing - The function to describes the safety corridors of the path with Polyhedra  [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    [P, min_width] = corridor(G, path, start, target, obstacles, smooth_number)
    %
    % Parameters:
    %   G should be the graph returned by edge_weight
    %
    %   path should be the array of l points returned by alt_graph.path 
    %
    %   start and target should be two points in dimension D
    %
    %   obstacles should be an array of N Polyhedron objects of dimension D
    %
    %   smooth_number should be a scalar. It is mainly used to have smooth
    %   corridors extremities.
    %
    % Return Values:
    %   P is an array of l-1 polyhedra of dimension D which represent the 
    %   safety corridors.
    %
    %   min_width is the width of the narrowest corridor in the path
    %
    %
    % Warning - For now, the function only works in 2D and 3D cases ! 
    %
    % See also corridors, edge_weight, edge_weight_robot, alt_graph.path, draw_corridor
    
    %Coordinates of the nodes of the graph, corridor width for each edge of
    %the graph
    coords = G.Nodes.position;
    corridors_width = G.Edges.width;

    %Initialization of the values of interest (described above)
    l = length(path);
    D = width(G.Nodes.position);
    P = repmat(Polyhedron(), l+1, 1);

    %Case where the path is just an edge from start to target
    if l == 0
        width_start = corridors.edge_width(start, target, obstacles);
        min_width = width_start;
        P(1) = corridors.draw_corridor(D, start, target, width_start, n);
        
    %Other cases
    else

        %Computation of the width of the starting corridor and of the width of the ending corridor
        start_junction = coords(path(1),:);
        target_junction = coords(path(l),:);

        width_start = corridors.edge_width(start, start_junction, obstacles);
        width_target = corridors.edge_width(target_junction, target, obstacles);
    
        min_width = min(width_start,width_target);
        
        %For each edge in the graph, 
        for i=1:(l-1)
            %Finding the edge corresponding to (path(i) path(i+1)) in the
            %graph to have the correct index for corridors_width
            index = findedge(G, path(i), path(i+1));

            %min_width and path_length updated with the new corridor/edge
            min_width = min(min_width, corridors_width(index));
        
            %Computation of the polyhedral representation of the corridor 
            A = [coords(path(i),:)];
            B = [coords(path(i+1),:)];
            P(i) = corridors.draw_corridor(D, A, B, corridors_width(index), n);

        end
        P(l) = corridors.draw_corridor(D, start, start_junction, width_start, n);
        P(l+1) = corridors.draw_corridor(D, target, target_junction, width_target, n);
    end
end
