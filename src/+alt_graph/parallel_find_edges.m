function edges = parallel_find_edges(polyhedra)
    n = height(polyhedra);
    edges_cell = cell(n);
    parfor i = 1:n
        edges_cell{i} = alt_graph.find_edges(polyhedra(i))
    end

    edges = vertcat(edges_cell{:});
end

