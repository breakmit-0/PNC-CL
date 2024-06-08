function facets = flatten_facets(polyhedra)
    % FLATTEN_FACETS Compute all facets of all polyhedron of polyhedra and
    % store them in a column vector of polyhedron
    %
    % Params:
    %     polyhedra: a column vector of polyhedron
    %
    % Returns:
    %     facets: a column vector of polyhedron containing all facets of
    %     all polyhedron of polyhedra


    n = height(polyhedra);
    facets_cell = cell(n, 1);

    for i = 1:n
        polyhedra(i).minHRep();
        facets_cell{i} = polyhedra(i).getFacet();
    end

    facets = vertcat(facets_cell{:});
end

