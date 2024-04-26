classdef BarycenterGraphBuilder < graph.GraphBuilder 
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
        function [G, vertexSet] = buildGraph(obj, src, dest, obstacles, partition)
            obj.clean();

            [srcPolyhedronI, destPolyhedronI, obstaclesSorted] = ...
                graph.GraphBuilder.validate(src, dest, obstacles, partition);

            for i = 1:width(partition)
                obj.add_barycenters(partition(i), ...
                    obstaclesSorted(i), ...
                    src, dest, ...
                    i == srcPolyhedronI, ...
                    i == destPolyhedronI);
            end

            srcI = obj.vertices.getIndex(src);
            destI = obj.vertices.getIndex(dest);

            obj.startNodes = [obj.startNodes; srcI; destI];
            obj.endNodes = [obj.endNodes; 
                obj.vertices.getIndex(obj.srcBarycenter); 
                obj.vertices.getIndex(obj.destBarycenter)];
            obj.weights = [obj.weights; 
                norm(src - obj.srcBarycenter); 
                norm(dest - obj.destBarycenter)];

            vertexSet = obj.vertices;
            G = graph(obj.startNodes, obj.endNodes, obj.weights);
            obj.clean();
        end
    end

    methods (Access=private)
        function obj = clean(obj)
            obj.vertices = graph.VertexSet();

            obj.srcBaryDist = realmax;
            obj.destBaryDist = realmax;
            obj.srcBarycenter = double.empty;
            obj.destBarycenter = double.empty;

            obj.startNodes = double.empty;
            obj.endNodes = double.empty;
            obj.weights = double.empty;
        end

        function obj = add_barycenters(obj, polyhedron, obstacle, src, dest, srcInside, destInside)
            polyhedron.minHRep();
            arrayfun(@(f) obj.add_barycenter(f, obstacle, src, dest, srcInside, destInside), polyhedron.getFacet());
        end

        function obj = add_barycenter(obj, facet, obstacle, src, dest, srcInside, destInside)
            import util.barycenter;
            import graph.BarycenterGraphBuilder.*;

            facet.minHRep();

            c = barycenter(facet);
            [ci, new] = obj.vertices.getIndexn(c);
           
            if new % only add edges if it the first time we process this barycenter
                for ridge = facet.getFacet().'
                    rc = barycenter(ridge);
                    rci = obj.vertices.getIndex(rc);
                    
                    obj.startNodes = [obj.startNodes; ci];
                    obj.endNodes = [obj.endNodes; rci];
                    obj.weights = [obj.weights; norm(c - rc)];
                end
            end

            if srcInside
                d = isBetterBarycenter(src, dest, c, obstacle, obj.srcBaryDist);

                if d >= 0
                    obj.srcBarycenter = c;
                    obj.srcBaryDist = d;
                end
            end
            if destInside
                d = isBetterBarycenter(dest, src, c, obstacle, obj.destBaryDist);
                
                if d >= 0
                    obj.destBarycenter = c;
                    obj.destBaryDist = d;
                end
            end
        end
    end

    methods (Access=private, Static)
        function [dist] = isBetterBarycenter(src, dest, center, obstacle, best_dist)
            dist = -1;
            d = norm(src - center) + norm(center - dest);

            if d < best_dist
                p = Polyhedron('V', src, 'R', center - src);
                if p.intersect(obstacle).isEmptySet()
                    dist = d;
                end
            end
        end
    end
end

