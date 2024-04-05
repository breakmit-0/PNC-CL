classdef BarycenterPathFinder < graph.PathFinder 
    %BARYCENTERPATHFINDER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        vertices = graph.VertexSet(),

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

                obj.add_barycenters(p, obstacle, src, dest, srcInside, destInside);
            end

            srcI = obj.vertices.get_index(src);
            destI = obj.vertices.get_index(dest);

            obj.startNodes = [obj.startNodes; srcI; destI];
            obj.endNodes = [obj.endNodes; 
                obj.vertices.get_index(obj.srcBarycenter); 
                obj.vertices.get_index(obj.destBarycenter)];
            obj.weights = [obj.weights; 
                norm(src - obj.srcBarycenter); 
                norm(dest - obj.destBarycenter)];

            vertexSet = obj.vertices;
            G = graph(obj.startNodes, obj.endNodes, obj.weights);
            [path, dist] = shortestpath(G, srcI, destI);
            disp(dist)
            obj.clean();
        end
    end

    methods (Access=private)
        function obj = clean(obj)
            obj.vertices = graph.VertexSet();
            obj.srcBaryDist = realmax;
            obj.destBaryDist = realmax;
        end

        function obj = add_barycenters(obj, polyhedron, obstacle, src, dest, srcInside, destInside)
            polyhedron.minHRep();
            arrayfun(@(f) obj.add_barycenter(f, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
        end

        function obj = add_barycenter(obj, facet, obstacle, src, dest, srcInside, destInside)
            import util.barycenter;

            facet.minHRep();

            c = barycenter(facet);
            [ci, new] = obj.vertices.get_indexn(c);
           
            if new % only add edges if it the first time we process this barycenter
                for ridge = facet.getFacet().'
                    rc = barycenter(ridge);
                    rci = obj.vertices.get_index(rc);
                    
                    obj.startNodes = [obj.startNodes; ci];
                    obj.endNodes = [obj.endNodes; rci];
                    obj.weights = [obj.weights; norm(c - rc)];
                end
            end

            if srcInside
                d = norm(src - c);
                p = Polyhedron('V', src, 'R', c - src);

                if d < obj.srcBaryDist  && p.intersect(obstacle).isEmptySet()
                    obj.srcBarycenter = c;
                    obj.srcBaryDist = d;
                end
            end

            if destInside
                d = norm(dest - c);
                p = Polyhedron('V', dest, 'R', c - dest);

                if d < obj.destBaryDist  && p.intersect(obstacle).isEmptySet()
                    obj.destBarycenter = c;
                    obj.destBaryDist = d;
                end
            end
        end
    end
end

