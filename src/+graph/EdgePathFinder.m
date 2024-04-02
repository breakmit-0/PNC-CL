classdef EdgePathFinder < graph.PathFinder
    % graph.EdgePathFinder Path finder class that allows objects to move only on
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
        function [G, path, vertexSet] = pathfinder(obj, src, dest, obstacles, partition)
            obj.clean();

            for p = partition.'
                src_inside = p.contains(src.');
                dest_inside = p.contains(dest.');

                obstacle = obstacles(1);
                for o = obstacles.'
                    if p.contains(o.randomPoint())
                        obstacle = o;
                        break
                    end
                end

                obj.add_edges_of_polyhedron(p, p.Dim, obstacle, src, dest, src_inside, dest_inside);
            end


            vertexSet = graph.VertexSet();
            startNodes = zeros(obj.edges.numEntries() + 4, 1);
            endNodes = zeros(obj.edges.numEntries() + 4, 1);
            weights = zeros(obj.edges.numEntries() + 4, 1);

            i = 1;
            for edge = obj.edges.keys().'
                i1 = vertexSet.get_index(edge.V1);
                i2 = vertexSet.get_index(edge.V2);

                if edge == obj.src_edge
                    i3 = vertexSet.get_index(src);
                    i4 = vertexSet.get_index(obj.src_proj);

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
                    i3 = vertexSet.get_index(dest);
                    i4 = vertexSet.get_index(obj.dest_proj);

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
            [path, ~] = shortestpath(G, vertexSet.get_index(src), vertexSet.get_index(dest));

            obj.clean();
        end
    end

    methods (Access=private)

        function obj = clean(obj)
            % Clean Clean EdgePathFinder: remove all edges and reset
            % srcProjDist and destProjDist.

            obj.edges.remove(obj.edges.keys);
            obj.src_proj_dist = realmax;
            obj.dest_proj_dist = realmax;
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

            import graph.EdgePathFinder.*;

            V1 = pEdge.V(1, :);
            V2 = pEdge.V(2, :);
            edge = graph.Edge(V1, V2);
            obj.edges = obj.edges.insert(edge, obj.edges.numEntries(), Overwrite=false);

            if srcInside
                [proj, dist, alpha] = graph.EdgePathFinder.project_point_into_line(src, V1, V2);
                p = Polyhedron('V', src, 'R', proj - src);

                % check if the projection is inside the line
                if 0 <= alpha && alpha <= 1 && dist < obj.src_proj_dist && p.intersect(obstacle).isEmptySet()
                    obj.src_edge = edge;
                    obj.src_proj = proj;
                    obj.src_proj_dist = dist;
                end
            end
            if destInside
                [proj, dist, alpha] = graph.EdgePathFinder.project_point_into_line(dest, V1, V2);
                p = Polyhedron('V', dest, 'R', proj - dest);

                % check if the projection is inside the line
                if 0 <= alpha && alpha <= 1 && dist < obj.dest_proj_dist && p.intersect(obstacle).isEmptySet()
                    obj.dest_edge = edge;
                    obj.dest_proj = proj;
                    obj.dest_proj_dist = dist;
                end
            end
        end
    end

    methods (Access=private, Static)
        function [proj, dist, alpha] = project_point_into_line(P, V1, V2)
            % project_point_into_line Project P into the line defined by V1
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

