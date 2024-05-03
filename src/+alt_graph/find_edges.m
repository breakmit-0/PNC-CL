function edge_list = find_edges(polys)
    import alt_graph.*;

    edge_list = polys;
    
    % fprintf("begin loop\n");

    while edge_list(1).Dim - size(edge_list(1).He, 1) > 1
        edge_list = flatten_facets(edge_list);
    end

end
