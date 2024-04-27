function out = gen_graph(edges)
    EPS = 0.001;

    N = size(edges, 1);
    dim = edges.Dim;

    vertices = [];

    % len / dim should be a decent guess for number of actual edges
    % although a slight underestimate as world edges are not duplicated
    num_edges = -ones(round(N/dim), 2, "uint32");

    
    store = 1;
    for i = 1:N
        v1 = edges(i).V(1, :);
        v2 = edges(i).V(2, :);

        n1 = 0;
        n2 = 0;

        % fprintf("--\nstarting with %d vertices\n", size(vertices, 1));
        
        for j = 1:size(vertices, 1)
            if norm(v1 - vertices(j, :)) < EPS
                % fprintf("assign n1 = %d\n", j);
                n1 = j;
            end
            if norm(v2 - vertices(j, :)) < EPS
                % fprintf("assign n2 = %d\n", j);
                n2 = j;
            end
            if n1 > 0 && n2 > 0
                break;
            end
        end

        if n1 == 0
            vertices(end+1, :) = v1;
            n1 = size(vertices, 1);
            % fprintf("creating new for n1 (%d)\n", n1);
        end

        if n2 == 0
            vertices(end+1, :) = v2;
            n2 = size(vertices, 1);
            % fprintf("creating new for n2 (%d)\n", n2);
        end
   
        num_edges(store, 1) = min(n1, n2);
        num_edges(store, 2) = max(n1, n2);
        store = store + 1;
    end

    % disp(num_edges);

    node_data = table(vertices, 'VariableNames', {'position'});

    edges = unique(num_edges, 'rows');
    distances = sqrt(sum((vertices(edges(:,1), :) - vertices(edges(:,2), :)).^2, 2));

    % add weights with a 'Weight' property
    edge_table = table(edges, distances, 'VariableNames', {'EndNodes', 'Weight'});

    out = graph(edge_table, node_data);
end


