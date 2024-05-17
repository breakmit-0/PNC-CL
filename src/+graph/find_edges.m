function edge_list = find_edges(polys)
    edge_list = polys;
    while edge_list(1).Dim - size(edge_list(1).He, 1) > 1
        edge_list = graph.flatten_facets(edge_list);
    end
end
