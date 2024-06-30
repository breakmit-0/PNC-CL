function width = edge_width(A, B, obstacles)
% edge_width - The function to compute the width of the safety corridor corresponding to an edge of the graph described by its extremities, depending on the distance between this edge and each obstacle [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    width = edge_width(A, B, obstacles)
    %
    % Parameters:
    %   A and B should be two points in dimension D, the edge extremities 
    %   Obstacles should be an array of N Polyhedron objects of dimension D
    % 
    %
    % Return Values:
    %   width is the distance between the edge and the nearest obstacle
    %
    % See also corridors, corridor_width, corridor_post_processing
    
    N = length(obstacles);
    d_obstacles = zeros(N,1);
    Q = Polyhedron('V',[A;B]);
    for j=1:N
        ret = distance(obstacles(j),Q);
        d_obstacles(j) = ret.dist;
    end
    width = min(d_obstacles);
end
