function [vertices, num_edges] = unpoly_edges(edges)
    % Convert Polyhedron edges to an array of index edges
    % as well as a position map, order and number of edges is preserved
    arguments
        edges (:, 1) Polyhedron;
    end

    
    N = height(edges);
    D = edges.Dim;

    vertices = zeros(N, D);

    num_edges = zeros(N, 2, "uint32");

    storeV = 0;
    for i = 1:N 
        edges(i).minVRep();

        if (height(edges(i).V) ~= 2)
            error("all edges must be dimension 1 and bounded");
        end

        v1 = edges(i).V(1, :);
        v2 = edges(i).V(2, :);

        n1 = 0;
        n2 = 0;

        for j = 1:storeV
            if norm(v1 - vertices(j, :), 1) < EPS
                n1 = j;
            end
            if norm(v2 - vertices(j, :), 1) < EPS
                n2 = j;
            end
            if n1 > 0 && n2 > 0
                break;
            end
        end

        if n1 == 0
            storeV = storeV + 1;
            vertices(storeV, :) = v1;
            n1 = storeV;
        end

        if n2 == 0
            storeV = storeV + 1;
            vertices(storeV, :) = v2;
            n2 = storeV;
        end
   
        num_edges(i, 1) = min(n1, n2);
        num_edges(i, 2) = max(n1, n2);
    end

    vertices = vertices(1:storeV, :);

end
