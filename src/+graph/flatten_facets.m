function facets = flatten_facets(polyhedra)
    n = height(polyhedra);
    facets_cell = cell(n, 1);

    for i = 1:n
        polyhedra(i).minHRep();
        facets_cell{i} = polyhedra(i).getFacet();
    end

    facets = vertcat(facets_cell{:});
end

