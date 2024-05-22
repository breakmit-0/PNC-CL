function [edges, hints] = find_edges_hint(partition, polyhedra)

    N = height(partition);
    D = partition(1).Dim;
    assert(N == height(polyhedra));
    for i = 1:N
        assert(partition(i).Dim == D);
        assert(polyhedra(i).Dim == D);
    end

    facets = cell(N, 2);
    parfor i = 1:N
        polyhedra(i).minHRep();
        facets{i, 1} = partition(i).getFacet();
    end
    
    for i = 1:N
        Ni = height(facets{i,1});
        facets{i, 2}(1:Ni) = i;
    end

    edges1 = vertcat(facets{:, 1});
    hints1 = vertcat(facets{:, 2});

    if D == 2
        edges = edges1;
        hints = hints1;
        return;
    end

    %% ----------------

    F = height(uniques);
    facets2 = cell(F, 2);
    parfor i = 1:F
        facets2{i, 1} = uniques(i).getFacet();
    end

    for i = 1:F
        Ni = height(facets2{i, 1});
        facets2{i, 2}(1:Ni) = hints1(i);
    end

    edges = vertcat(facets2{:, 1});
    hints = vertcat(facets2{:, 2});


end

