classdef EdgeGraphBuilder < graph.GraphBuilder
    % graph.EdgeGraphBuilder Graph builder that create a graph based on
    % the edge of the partition.
    
    properties (Access = private)
        edges = configureDictionary("graph.Edge", "int32"),
        src_edge graph.Edge,
        src_proj double,
        src_proj_dist = realmax,
        dest_edge graph.Edge,
        dest_proj double,
        dest_proj_dist = realmax
    end

    methods        
        function [G, vertexSet] = buildGraph(obj, src, dest, obstacles, partition)
            obj.clean();

            [srcPolyhedronI, destPolyhedronI, obstaclesSorted] = ...
                graph.GraphBuilder.validate(src, dest, obstacles, partition);

            for i = 1:width(partition)
                p = partition(i);

                obj.add_edges_of_polyhedron(p, ...
                    p.Dim, ...
                    obstaclesSorted(i), ...
                    src, dest, ...
                    i == srcPolyhedronI, ...
                    i == destPolyhedronI);
            end

            if isempty(obj.src_edge) || isempty(obj.dest_edge)
                error("Failed to link src or dest point to graph")
            end

            vertexSet = graph.VertexSet();
            startNodes = zeros(obj.edges.numEntries() + 4, 1);
            endNodes = zeros(obj.edges.numEntries() + 4, 1);
            weights = zeros(obj.edges.numEntries() + 4, 1);

            i = 1;
            for edge = obj.edges.keys().'
                i1 = vertexSet.getIndex(edge.V1);
                i2 = vertexSet.getIndex(edge.V2);

                if edge == obj.src_edge
                    i3 = vertexSet.getIndex(src);
                    i4 = vertexSet.getIndex(obj.src_proj);

                    startNodes(i) = i1;
                    endNodes(i) = i4;
                    weights(i) = norm(edge.V1 - obj.src_proj);

                    i = i + 1;
                    startNodes(i) = i2;
                    endNodes(i) = i4;
                    weights(i) = norm(edge.V2 - obj.src_proj);

                    i = i + 1;
                    startNodes(i) = i3;
                    endNodes(i) = i4;
                    weights(i) = norm(src - obj.src_proj);
                elseif edge == obj.dest_edge
                    i3 = vertexSet.getIndex(dest);
                    i4 = vertexSet.getIndex(obj.dest_proj);

                    startNodes(i) = i1;
                    endNodes(i) = i4;
                    weights(i) = norm(edge.V1 - obj.dest_proj);

                    i = i + 1;
                    startNodes(i) = i2;
                    endNodes(i) = i4;
                    weights(i) = norm(edge.V2 - obj.dest_proj);

                    i = i + 1;
                    startNodes(i) = i3;
                    endNodes(i) = i4;
                    weights(i) = norm(dest - obj.dest_proj);
                else
                    startNodes(i) = i1;
                    endNodes(i) = i2;
                    weights(i) = norm(edge.V1 - edge.V2);
                end
       
                i = i + 1;
            end
            
            G = graph(startNodes, endNodes, weights);
            obj.clean();
        end
    end

    methods (Access=private)

        function obj = clean(obj)
            % Clean Clean EdgePathFinder: remove all edges and reset
            % properties

            obj.edges.remove(obj.edges.keys);
            obj.src_proj_dist = realmax;
            obj.dest_proj_dist = realmax;
            obj.src_edge = graph.Edge.empty;
            obj.dest_edge = graph.Edge.empty;
        end


        function obj = add_edges_of_polyhedron(obj, polyhedron, dim, obstacle, src, dest, srcInside, destInside)
            % add_edges_of_polyhedron Add all edges of polyhedron to the 
            % list of edges
            %
            % Parameters:
            %     polyhedron: the polyhedron to extract edges from
            %     dim: dimension of polyhedron.
            %     obstacle: the obstacle contained by the polyhedron
            %     src: the source point
            %     dest: the destination point
            %     srcInside: true if the polyhedron contains src
            %     destInside: true if the polyhedron contains dest
            
            assert(dim >= 2)
            polyhedron.minHRep();
            if dim == 2
                arrayfun(@(f) obj.add_edge(f, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
            else
                arrayfun(@(f) obj.add_edges_of_polyhedron(f, dim - 1, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
            end
        end

        function obj = add_edge(obj, pEdge, obstacle, src, dest, srcInside, destInside)
            % add_edge Add pEdge to the list of edges
            %
            % If the source or the destination is inside the partition that
            % contains pEdge, the projection of src (or dest) is added.
            %
            % Parameters:
            %     pEdge: the edge to add. 
            %     obstacle: the obstacle contained by the polyhedron
            %     src: the source point
            %     dest: the destination point
            %     srcInside: true if the polyhedron contains src
            %     destInside: true if the polyhedron contains dest

            import graph.EdgeGraphBuilder.*;

            V1 = pEdge.V(1, :);
            V2 = pEdge.V(2, :);
            edge = graph.Edge(V1, V2);
            obj.edges = obj.edges.insert(edge, obj.edges.numEntries(), Overwrite=false);

            if srcInside
                [proj, dist] = isBetterEdge(src, dest, V1, V2, obstacle, obj.src_proj_dist);

                if dist >= 0 % if positive, it is always better
                    obj.src_edge = edge;
                    obj.src_proj = proj;
                    obj.src_proj_dist = dist;
                end
            end
            if destInside
                [proj, dist] = isBetterEdge(dest, src, V1, V2, obstacle, obj.dest_proj_dist);

                if dist >= 0 % if positive, it is always better
                    obj.dest_edge = edge;
                    obj.dest_proj = proj;
                    obj.dest_proj_dist = dist;
                end
            end
        end
    end

    methods (Access=private, Static)
        function [proj, dist] = isBetterEdge(src, dest, V1, V2, obstacle, best_dist)
            % ISBETTEREDGE Return positive distance if the edge defined by
            % V1 and V2 is better for minimizing distance between src and
            % dest.
            %
            % This function projects src into the line defined by V1 and
            % V2. If the projection is between V1 and V2, it calculates an
            % approximation of the distance between src and dest in the
            % graph: norm(src - proj) + norm(dest - proj). If this distance
            % is less than best_dist and if the ray starting at src and
            % pointing to proj doesn't intersect with obstacle, then 'dist'
            % is set to the approximative distance. Otherwise 'dist' is set
            % to -1.
            
            import graph.EdgeGraphBuilder.*;

            dist = -1;
            [proj, d, alpha] = projectPointIntoLine(src, V1, V2);

            % check if the projection is inside the line
            if 0 <= alpha && alpha <= 1
                d = d + norm(dest - proj);

                % check distance
                if d < best_dist 
                    p = Polyhedron('V', src, 'R', proj - src);

                    % check no obstacles
                    if p.intersect(obstacle).isEmptySet()
                        dist = d;
                    end
                end
            end
        end

        function [proj, dist, alpha] = projectPointIntoLine(P, V1, V2)
            % PROJECTPOINTINTOLINE Project P into the line defined by V1
            % and V2.
            % 
            % The function will fail if V1 = V2.
            %
            % Parameters:
            %     P: the point to project
            %     V1: first point of the line
            %     V2: second point of the line
            %
            % Return values:
            %     proj: the projection of P into the line
            %     dist: the distance between P and proj
            %     alpha: a coefficient indicating where proj is on line the
            %     relative to V1 and V2: alpha equals to 0 means that proj =
            %     V1, alpha = 1 implies proj = V2, 0 < alpha < 1 implies
            %     proj is located between V1 and V2 in the lie whereas alpha <
            %     0 or alpha > 1 implies that proj isn't between V1 and V2

            v = (V2 - V1) / norm(V2 - V1); % normalize vector from V1 to V2
            % dot(P - V1, v) is the distance between V1 and proj.
            d = dot(P - V1, v);
            proj = d * v + V1;
            dist = norm(P - proj);
            alpha = d / norm(V2 - V1);
        end
    end
end

