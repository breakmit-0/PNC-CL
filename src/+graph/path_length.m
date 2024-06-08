function length = path_length(G, path, start, dest)
    % PATH_LENGTH Compute the length of the path 'path' in graph G
    %
    % Params:
    %     G: graph who contains nodes' position in G.Nodes.position
    %     path: path in graph
    %     start: start point, can be outside the graph
    %     dest: destination point, can be outside the graph
    %
    % Returns:
    %     length: length of path 'path'

    if size(path) == 0
        if isempty(start) || isempty(dest)
            length = 0;
        else
            length = norm(start - dest);
        end
    else
        pos = G.Nodes.position;

        if isempty(start)
            % little hack
            start = pos(path(1), :);
        end

        if isempty(dest)
            dest = pos(path(end), :);
        end

        if size(path) == 1
            length = norm(start - pos(path(1), :)) + ...
                     norm(dest - pos(path(1), :));
        else
            P1 = pos(path(1), :);
            P2 = pos(path(end), :);
    
            length = norm(start - P1) + norm(dest - P2);
            for i = 1:(width(path) - 1)
                P1 = pos(path(i), :);
                P2 = pos(path(i + 1), :);
                length = length + norm(P1 - P2);
            end
        end
    end
end

