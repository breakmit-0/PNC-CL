classdef EdgeBuilder < GraphBuilder

    properties
        obstacles (:, 1) Polyhedron = [];
    end

    methods
        function obj = EdgeBuilder(obstacles)
            arguments
                obstacles (:, 1) Polyhedron = [];
            end
            obj.parallel = false;
            obj.obstacles = obstacles;
        end

        function G = buildGraph(obj, partition)
            if height(obj.obstacles) == 0
                pedges = graph.find_edges(partition);
                [vpos, edges] = graph.unpoly_edges(pedges);
                g = graph.create_graph(edges, vpos);

                G = LiftGraph(g);
                G.neighbour_info = false;
                G.width_info = false;
            else
                [pedges, hints] = graph.find_edges_hint(partition, obj.obstacles);
                [vpos, edges] = graph.unpoly_edges(pedges);
                g = graph.create_graph_hint(edges, vpos, hints);

                G = LiftGraph(g);
                G.neighbour_info = false;
                G.width_info = false;
            end
        end
    end
end

