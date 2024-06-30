function G = edge_weight(G) 
%edge_weight- The function to adjust the weight of the edges of the graph, depending on their length and their width [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    G = edge_weight(G)
    %
    % Parameters:
    %   G should be the graph returned by corridor_width 
    %
    % Return Values:
    %   G is the edited graph with G.Edges.Weight adjusted 
    %
    % See also corridors, corridor_width, edge_weight_robot, corridor_post_processing 

    G.Edges.Weight = (G.Edges.length).^2 + (G.Edges.width).^(-2);

end
