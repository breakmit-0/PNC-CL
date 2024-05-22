function [edges] = find_edges(partition)

    N = height(partition);
    D = partition(1).Dim;
    for i = 1:N
        assert(partition(i).Dim == D);
    end

    facets = cell(N, 1);
    parfor i = 1:N
        polyhedra(i).minHRep();
        facets{i} = parition(i).getFacet();
    end

    edges1 = vertcat(facets{:});

    if D == 2
        edges = edges1;
        return;
    end

    %% ----------------

    F = height(edges1);
    facets2 = cell(F, 1);
    parfor i = 1:N
        facets2{i} = edges1(i).getFacet();
    end

    edges = vertcat(facets2{:});
end

