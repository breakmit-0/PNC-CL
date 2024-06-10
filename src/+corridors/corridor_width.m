function G = corridor_width(G, obstacles)
% corridor_width - The function to compute the width of the safety corridors corresponding to the graph, depending on the distance between the edges and the obstacles  [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    G = corridor(G, obstacles)
    %
    % Parameters:
    %   G should be the graph returned by graphBuilder.buildGraph
    %   Obstacles should be an array of N Polyhedron objects of dimension D
    % 
    %
    % Return Values:
    %   G is the edited graph with 
    %   G.Edges.length = corridor_length  
    %   G.Edges.width = corridor_width
    %
    % See also corridors, edge_weight
    
    %Edges of the graph and coordinates of its nodes
    edges = G.Edges;
    coords = G.Nodes.position;

    %Initialization of the values of interest
    l = height(edges);
    G.Edges.length = zeros(l,1);
    G.Edges.width = zeros(l,1);
    
    for i=1:l
        %For each edge of the graph, the function calculates the distance
        %between this edge and each obstacle, and took the minimum for the
        %width of the corresponding corridor.
        edge = edges(i,:);
        extremities = edge.EndNodes;
        A = [coords(extremities(1),:)];
        B = [coords(extremities(2),:)];
        G.Edges.length(i) = edge.Weight; 
        G.Edges.width(i) = corridors.edge_width(A, B, obstacles);
    end
end
