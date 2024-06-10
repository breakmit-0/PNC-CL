function width = edge_width(A, B, obstacles)
    
    N = length(obstacles);
    d_obstacles = zeros(N,1);
    Q = Polyhedron('V',[A;B]);
    for j=1:N
        ret = distance(obstacles(j),Q);
        d_obstacles(j) = ret.dist;
    end
    width = min(d_obstacles);
end