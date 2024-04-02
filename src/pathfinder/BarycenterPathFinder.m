classdef BarycenterPathFinder < PathFinder
    %BARYCENTERPATHFINDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vertices = VertexSet(),

        srcBarycenter double,
        srcBaryDist = realmax,
        destBarycenter double,
        destBaryDist = realmax,

        startNodes double,
        endNodes double,
        weights double
    end
    
    methods
        function [G, path, vertexSet] = pathfinder(obj, src, dest, obstacles, partition)
            obj.clean();

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

                obj.addBarycenters(p, obstacle, src, dest, srcInside, destInside);
            end

            srcI = obj.vertices.getIndex(src);
            destI = obj.vertices.getIndex(dest);

            obj.startNodes = [obj.startNodes; srcI; destI];
            obj.endNodes = [obj.endNodes; 
                obj.vertices.getIndex(obj.srcBarycenter); 
                obj.vertices.getIndex(obj.destBarycenter)];
            obj.weights = [obj.weights; 
                distance(src, obj.srcBarycenter); 
                distance(dest, obj.destBarycenter)];

            vertexSet = obj.vertices;
            G = graph(obj.startNodes, obj.endNodes, obj.weights);
            [path, ~] = shortestpath(G, srcI, destI);

            obj.clean();
        end
    end

    methods (Access=private)
        function obj = clean(obj)
            obj.vertices = VertexSet();
            obj.srcBaryDist = realmax;
            obj.destBaryDist = realmax;
        end

        function obj = addBarycenters(obj, polyhedron, obstacle, src, dest, srcInside, destInside)
            polyhedron.minHRep();
            arrayfun(@(f) obj.addBarycenter(f, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
        end

        function obj = addBarycenter(obj, facet, obstacle, src, dest, srcInside, destInside)
            facet.minHRep();

            c = barycenter(facet);
            [ci, new] = obj.vertices.getIndexN(c);
           
            if new % only add edges if it the first time we process this barycenter
                for ridge = facet.getFacet().'
                    rc = barycenter(ridge);
                    rci = obj.vertices.getIndex(rc);
                    
                    obj.startNodes = [obj.startNodes; ci];
                    obj.endNodes = [obj.endNodes; rci];
                    obj.weights = [obj.weights; distance(c, rc)];
                end
            end

            if srcInside
                d = distance(src, c);
                p = Polyhedron('V', src, 'R', c - src);

                if d < obj.srcBaryDist  && p.intersect(obstacle).isEmptySet()
                    obj.srcBarycenter = c;
                    obj.srcBaryDist = d;
                end
            end

            if destInside
                d = distance(dest, c);
                p = Polyhedron('V', dest, 'R', c - dest);

                if d < obj.destBaryDist  && p.intersect(obstacle).isEmptySet()
                    obj.destBarycenter = c;
                    obj.destBaryDist = d;
                end
            end
        end
    end
end

