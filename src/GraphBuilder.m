classdef GraphBuilder
    % graph.GraphBuilder Base class for all graph builder


    methods (Static)
        function gb = default()
            gb = graph.EdgeBuilder();

        end

        function gb = edges(obstacles)
            gb = graph.EdgeBuilder(obstacles);
        end

        function gb = barycenters(obstacles)
            gb = graph.BaryBuilder(obstacles);
        end
    end

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

