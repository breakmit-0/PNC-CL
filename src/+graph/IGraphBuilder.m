classdef IGraphBuilder < handle
    % graph.GraphBuilder Base class for all graph builder

    methods (Abstract)
        G = buildGraph(obj, partition)
        % Find a path between src and dest without going into
        % an obstacle and moving on the facets of partition
        % 
        % Parameters:
        %     partition: column vector of Polyhedron, it forms a partition 
        %     of the space. One Polyhedron of paritition contains one and 
        %     only one obstacle.
        %
        % Return values:
        %     G: graph
    end
end

