function out = plot_path(g, start, target, path)
    arguments
        g (1, 1) graph;
        start (1, :) double;
        target (1, :) double;
        path (1, :) uint32;
    end

    assert(size(start, 2) == size(target, 2));

    xyz = [start; g.Nodes.position(path, :); target];

    if size(start, 2) == 2
        plot(xyz(:, 1), xyz(:, 2), 'Color', 'g', 'LineWidth', 5);
    else 
        plot3(xyz(:, 1), xyz(:, 2), xyz(:,3), 'Color', 'g', 'LineWidth', 5); 
    end

end
