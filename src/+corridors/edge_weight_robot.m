function G = edge_weight_robot(G, robot) 
%edge_weight_robot - The function to adjust the weight of the edges of the graph, depending on their length, their width and the robot dimensions [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    G = edge_weight(G, robot)
    %
    % Parameters:
    %   G should be the graph returned by corridor_width
    %   robot should be a Polyhedron object
    %
    % Return Values:
    %   G is the edited graph with G.Edges.Weight adjusted 
    %
    % See also corridors, corridor, corridor_width, edge_weight
    
    %Computing the radius of the robot
    bary = util.barycenter(robot);
    robot_radius = 0;
    points = robot.V;
    n = height(points);
    for i=1:n
        point = points(i,:);
        if norm(point-bary)>robot_radius
            robot_radius = norm(point-bary);
        end
    end
    disp("robot radius : " + robot_radius)
    
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