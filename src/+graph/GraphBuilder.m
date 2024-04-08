classdef GraphBuilder < handle
    % graph.GraphBuilder Base class for all graph builder

    methods (Access=protected, Static)
        function [srcPolyhedronI, destPolyhedronI, obstaclesSorted] ...
            = validate(src, dest, obstacles, partition)
            % VALIDATE Validate entries for build_graph
            % 
            % Check that:
            % * obstacles and partiton have the same dimension and they are
            % both row vectors.
            % * src and dest are inside at least on polyhedron of partition
            % * all partition contains one and only one polyhedron of
            % obstacles

            % check obstacles and partition size
            [R, C] = size(obstacles);
            if R ~= 1
                error("Obstacles should be a row vector")
            end
            if C == 0
                error("Empty obstacles vector")
            end

            if any([R, C] ~= size(partition))
                error("Partition vector didn't have the same size as obstacles.")
            end

            % check a polyhedron of partition contains one polyhedron of
            % obstacles
            % convert the vector of obstacles to a linked list
            ob_head = graph.Node.rowVectorToLinkedList(obstacles);
            obstaclesSorted = repmat(Polyhedron(), 1, width(obstacles));
            srcPolyhedronI = -1;
            destPolyhedronI = -1;

            % iterate over the partition
            i = 1;
            for p = partition
                % iterate over the remaining obstacles
                % breaking when an obstacle is contained inside 'p'
                node = ob_head;
                while ~isempty(node)
                    if p.contains(node.value)
                        break
                    end

                    node = node.next;
                end

                % exit if no obstacle was found
                if isempty(node)
                    error("One polyhedron of partition (index: " + i + ") didn't contains an obstacle")
                end


                % check for src and dest polyhedron
                if p.contains(src.')
                    srcPolyhedronI = i;

                    if node.value.contains(src.')
                        error("An obstacle contains the source point")
                    end
                end
                if p.contains(dest.')
                    destPolyhedronI = i;

                    if node.value.contains(dest.')
                        error("An obstacle contains the destination point")
                    end
                end            

                % append obstacle
                obstaclesSorted(i) = node.value;
                i = i + 1;

                % remove the node, only if there are more than one
                % obstacle, otherwise it is impossible to remove the node.
                if i ~= width(obstacles)
                    if isempty(node.prev)
                        % remove the head, so the head is the ob_head.next
                        % which is returned by remove()
                        ob_head = node.remove();
                    else
                        node.remove();
                    end
                end
            end

            % check that src and dest are inside a partition
            if srcPolyhedronI < 0
                error("Source point not in a polyhedron")
            end
            if destPolyhedronI < 0
                error("Destination point not in a polyhedron")
            end
        end
    
    end



 
    methods (Abstract)
        [G, vertexSet] = buildGraph(obj, src, dest, obstacles, partition)
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
        %     path: path in G
        %     vertices: vertices(i, :) represents the position of the i-th node
        %     of the graph in the space.
    end
end

