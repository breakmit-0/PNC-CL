function out = total_vertices(obstacles)
    
    N = size(obstacles, 1);
    out = 0;

    for obs = 1:N
        for vertex_id = 1:size(obstacles(obs).V, 1)
            out = out + N;
        end
        out = out + 2;
    end
end
