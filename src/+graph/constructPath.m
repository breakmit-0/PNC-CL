function path = constructPath(G, vNodes, start, dest, length)

    path = struct('V', 0, 'length', 0, 'visited_nodes', 0, 'size', 0);

    path.V = [start;table2array(G.Nodes(vNodes,:));dest];
    path.length = length;
    path.visited_nodes = vNodes;
    path.size = size(path.V,1);

end