classdef GraphBuilder < handle
    % graph.GraphBuilder Base class for all graph builder

    methods (Abstract)
        G = buildGraph(obj, partition)
        % Find a path between src and dest without going into
        % an obstacle and moving on the facets of partition
        % 
        % Parameters:
        %     src: column vector of float, where the path starts
        %     dest: column vector of float, where the path ends
        %     obstacles: column vector of Polyhedron, the obstacles
        %     partition: column vector of Polyhedron, it forms a partition 
        %     of the space. One Polyhedron of paritition contains one and 
        %     only one obstacle.
        %
        % Return values:
        %     G: graph
    end
end

