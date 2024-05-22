function g = create_graph_hint(edges, vpos, poly_hints)
    arguments
        edges (:, 2) uint32;
        vpos (:, :) double;
        poly_hints (:, 1) uint32 = [];
    end

    D = width(vpos);

    unique_edges = unique(edges, 'rows');
    N = height(unique_edges);

    hints = zeros(N, D);

    for i = 1:N
        dups = ismember(edges, unique_edges(i, :), 'rows');
        dups = dups(dups ~= 0);

        for j = 1:height(dups)
            hints(i, 2 + j) = poly_hints(dups(j));
        end
    end

    sq_distances =  (vpos(edges(:,1), :) - vpos(edges(:,2), :) ).^2;
    distances = sqrt(sum(sq_distances, 2));

    node_data = table(vertices, 'VariableNames', {'position'});
    edge_table = table(edges, distances, hints, 'VariableNames', {'EndNodes', 'Weight', 'PolyHints'});

    g = graph(edge_table, node_data);
    
end
