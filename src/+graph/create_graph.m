function g = create_graph_hint(edges, vpos)
    arguments
        edges (:, 2) uint32;
        vpos (:, :) double;
    end


    unique_edges = unique(edges, 'rows');

    sq_distances =  (vpos(edges(:,1), :) - vpos(edges(:,2), :) ).^2;
    distances = sqrt(sum(sq_distances, 2));

    node_data = table(vertices, 'VariableNames', {'position'});
    edge_table = table(unique_edges, distances, 'VariableNames', {'EndNodes', 'Weight'});

    g = graph(edge_table, node_data);
end
