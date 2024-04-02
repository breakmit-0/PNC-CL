classdef PathFinder < handle
    %PATHFINDER Base class for all path finder
 
    methods (Abstract)
        [G, path, vertices] = pathfinder(obj, src, dest, obstacles, partition)
        % Find a path between src and dest without going into
        % an obstacle and moving on the facets of partition
        % 
        % Parameters:
        % src: column vector of float, where the path starts
        % dest: column vector of float, where the path ends
        % obstacles: column vector of Polyhedron, the obstacles
        % partition: column vector of Polyhedron, it forms a partition
        % of the space. One Polyhedron of paritition contains one and only
        % one obstacle.
        %
        % Returns:
        % G: graph
        % path: path in G
        % vertices: vertices(i, :) represents the position of the i-th node
        % of the graph in the space.
    end
end

