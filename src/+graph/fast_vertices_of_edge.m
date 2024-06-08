function V = fast_vertices_of_edge(edge)
    % FAST_VERTICES_OF_EDGE Compute the two vertices of an edge in H-rep 
    % without computing the V-Rep or the minimal H-Rep.
    %
    % Params:
    %     edge: an Polyhedron which should be an edge. No check is
    %     performed
    %
    % Returns:
    %     V: a 2-line matrix containing the two vertice of the edge.
    %
    % Fast methods to compute the barycenter of an edge in 3D.
    % https://or.stackexchange.com/questions/4540/how-to-find-all-vertices-of-a-polyhedron/4541#4541
    % Instead of using the optimized version for general use, we use the
    % naive one but because we have edges, it is simpler and faster. In
    % fact, we just need to solve multiple linear systems, because it's an 
    % edge) instead of solving multiple optimisation problems.

    if height(edge.A) == 2
        V1 = linsolve([edge.Ae; edge.A(1, :)], [edge.be; edge.b(1,:)]);
        V2 = linsolve([edge.Ae; edge.A(2, :)], [edge.be; edge.b(2,:)]);

        V = [V1.'; V2.'];
    else
        V1 = [];

        for i = 1:height(edge.A)
            [vertex, ~] = linsolve([edge.Ae; edge.A(i, :)], [edge.be; edge.b(i,:)]);

            if ~anynan(vertex) && all(vertex ~= inf) && edge.contains(vertex)
                if isempty(V1)
                    V1 = vertex;
                else
                    V = [V1.'; vertex.'];
                    return
                end
            end
        end

        warning("Failed to calculate vertices of edge using fast " + ...
            "method. Falling back to default method. This often " + ...
            "indicates a problem in the partition or the lifting")
        V = edge.V;
    end
end

