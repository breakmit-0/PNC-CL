function best_n = best_start_no_shortcut(g, start, target, obstacles, partition)
    % identitify in which partition start is
    i = -1;
    for j = 1:(height(partition))
        if partition(j).contains(start.')
            i = j;
            break
        end
    end

    vertices = g.Nodes.position;

    if i <= 0
        % start is outside the partition, link with the point minimizing
        % the distance between start and target. BUT choose the point such
        % as, the line between start and the point have an empty or a
        % single point intersection with all elements of the partition
        dist = sqrt (sum((vertices - start).^2, 2)) + ...
               sqrt (sum((vertices - target).^2, 2));
        [~, I] = sort(dist);

        for j = 1:size(I)
            point = vertices(I(j), :);
            sline = Polyhedron('V', [start; point]);
    
            intersects = false;
            for p = partition.'
                % sol = p.shoot((point - start).', start.');
                % sol2 = p.shoot((start - point).', point.');
                % no_intersection = isinf(sol.alpha) || ...
                %     ~((1e-7 < sol.alpha && sol.alpha < 1 - 1e-7) || (1e-7 < sol2.alpha && sol2.alpha < 1 - 1e-7)) 

                intersection = p.and(sline);
                intersection.minVRep();

                if height(intersection.V) >= 2
                    intersects = true;
                    break;
                end
            end
            
            if ~intersects
                best_n = I(j);
                return
            end
        end
    else
        p = partition(i);

        % find the obstacle which is inside partition(i)
        oi = -1;
        for j = 1:(height(obstacles))
            if p.contains(obstacles(j))
                oi = j;
                break
            end
        end

        % filter points that are inside the partition
        n = height(vertices);
        indices = 1:n;
        indices = indices(p.contains(vertices.'));
        vertices = vertices(indices, :);

        % sort
        dist = sqrt (sum((vertices - start).^2, 2)) + ...
               sqrt (sum((vertices - target).^2, 2));
        [~, I] = sort(dist);

        for j = 1:size(I)
            point = vertices(I(j), :);
            sline = Polyhedron('V', [start; point]);
    
            if obstacles(oi).and(sline).isEmptySet()
                best_n = indices(I(j));
                return
            end
        end
    end

    best_n = -1;
end

