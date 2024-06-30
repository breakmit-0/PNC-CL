function G = edge_weight_robot(G, robot) 
%edge_weight_robot - The function to adjust the weight of the edges of the graph, depending on their length, their width and the robot dimensions [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    G = edge_weight_robot(G, robot)
    %
    % Parameters:
    %   G should be the graph returned by corridor_width
    %   robot should be a Polyhedron object
    %
    % Return Values:
    %   G is the edited graph with G.Edges.Weight adjusted 
    %
    % See also corridors, corridor_width, edge_weight, corridor_post_processing
    
    %Computing the radius of the robot
    robot_radius = util.radius(robot);
    
    %Adjusting the weights : if the width of an edge is smaller than the
    %robot radius, then the weight of this edge is infinite. This prevents
    %the robot from using this edge to navigate.
    edges = G.Edges;
    l = height(edges);

    for i=1:l
        edge = edges(i,:);
        if edge.width < robot_radius
            G.Edges.Weight(i) = +inf;
        else
            G.Edges.Weight(i) = (G.Edges.length(i)).^2 + (G.Edges.width(i)).^(-2);
        end
    end
end
