function length = path_length(G, path, start, dest)
    if size(path) == 0
        length = norm(start - dest);
    elseif size(path) == 1
        length = norm(start - G.Nodes.position(path(1))) + ...
                 norm(dest - G.Nodes.position(path(1)));
    else
        P1 = G.Nodes.position(path(1));
        P2 = G.Nodes.position(path(end));

        length = norm(start - P1) + norm(dest - P2);
        for i = 1:(size(path) - 1)
            edge_index = findedge(G, path(i), path(i+1));
            length = length + G.Edges.length(edge_index);
        end
    end
end

