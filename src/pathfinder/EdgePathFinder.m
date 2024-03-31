classdef EdgePathFinder < handle
    %EDGEPATHFINDER Path finder class that allows objects to move only on
    %the edge of the partition.
    
    properties (Access = private)
        edges = configureDictionary("Edge", "int32"),
        srcEdge Edge,
        srcProj double,
        srcProjDist = realmax,
        destEdge Edge,
        destProj double,
        destProjDist = realmax
    end

    methods        
        function [G, path, vertexSet] = pathfinder(obj, src, dest, obstacles, partition)
            for p = partition.'
                srcInside = p.contains(src.');
                destInside = p.contains(dest.');

                obstacle = obstacles(1);
                for o = obstacles.'
                    if p.contains(o.randomPoint())
                        obstacle = o;
                        break
                    end
                end

                obj.addEdgesOfPolyhedron(p, p.Dim, obstacle, src, dest, srcInside, destInside);
            end


            disp("Edges created. Creating graph.")
            vertexSet = VertexSet();
            startNodes = zeros(obj.edges.numEntries() + 4, 1);
            endNodes = zeros(obj.edges.numEntries() + 4, 1);
            weights = zeros(obj.edges.numEntries() + 4, 1);

            i = 1;
            for edge = obj.edges.keys().'
                i1 = vertexSet.getIndex(edge.V1);
                i2 = vertexSet.getIndex(edge.V2);

                if edge == obj.srcEdge
                    i3 = vertexSet.getIndex(src);
                    i4 = vertexSet.getIndex(obj.srcProj);

                    startNodes(i) = i1;
                    endNodes(i) = i4;
                    weights(i) = distance(edge.V1, obj.srcProj);

                    i = i + 1;
                    startNodes(i) = i2;
                    endNodes(i) = i4;
                    weights(i) = distance(edge.V2, obj.srcProj);

                    i = i + 1;
                    startNodes(i) = i3;
                    endNodes(i) = i4;
                    weights(i) = distance(src, obj.srcProj);
                elseif edge == obj.destEdge
                    i3 = vertexSet.getIndex(dest);
                    i4 = vertexSet.getIndex(obj.destProj);

                    startNodes(i) = i1;
                    endNodes(i) = i4;
                    weights(i) = distance(edge.V1, obj.destProj);

                    i = i + 1;
                    startNodes(i) = i2;
                    endNodes(i) = i4;
                    weights(i) = distance(edge.V2, obj.destProj);

                    i = i + 1;
                    startNodes(i) = i3;
                    endNodes(i) = i4;
                    weights(i) = distance(dest, obj.destProj);
                else
                    startNodes(i) = i1;
                    endNodes(i) = i2;
                    weights(i) = distance(edge.V1, edge.V2);
                end
       
                i = i + 1;
            end
            
            G = graph(startNodes, endNodes, weights);
            [path, ~] = shortestpath(G, vertexSet.getIndex(src), vertexSet.getIndex(dest));
        end
    end

    methods (Access=private)
        function obj = addEdgesOfPolyhedron(obj, polyhedron, dim, obstacle, src, dest, srcInside, destInside)
            assert(dim >= 2)
            polyhedron.minHRep();
            if dim == 2
                arrayfun(@(f) obj.addEdge(f, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
            else
                arrayfun(@(f) obj.addEdgesOfPolyhedron(f, dim - 1, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
            end
        end

        function obj = addEdge(obj, pEdge, obstacle, src, dest, srcInside, destInside)
            V1 = pEdge.V(1, :);
            V2 = pEdge.V(2, :);
            edge = Edge(V1, V2);
            obj.edges = obj.edges.insert(edge, obj.edges.numEntries(), Overwrite=false);

            if srcInside
                [proj, dist, alpha] = EdgePathFinder.projectPointIntoLine(src, V1, V2);
                p = Polyhedron('V', src, 'R', proj - src);

                % check if the projection is inside the line
                if 0 <= alpha && alpha <= 1 && dist < obj.srcProjDist && p.intersect(obstacle).isEmptySet()
                    obj.srcEdge = edge;
                    obj.srcProj = proj;
                    obj.srcProjDist = dist;
                end
            end
            if destInside
                [proj, dist, alpha] = EdgePathFinder.projectPointIntoLine(dest, V1, V2);
                p = Polyhedron('V', dest, 'R', proj - dest);

                % check if the projection is inside the line
                if 0 <= alpha && alpha <= 1 && dist < obj.destProjDist  && p.intersect(obstacle).isEmptySet()
                    obj.destEdge = edge;
                    obj.destProj = proj;
                    obj.destProjDist = dist;
                end
            end
        end
    end

    methods (Access=private, Static)
        function [proj, dist, alpha] = projectPointIntoLine(P, V1, V2)
            v = (V2 - V1) / norm(V2 - V1); % normalize vector from V1 to V2
            % dot(P - V1, v) is the distance between V1 and proj.
            d = dot(P - V1, v);
            proj = d * v + V1;
            dist = norm(P - proj);
            alpha = d / norm(V2 - V1);
        end
    end
end

