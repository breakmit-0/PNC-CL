classdef EdgeGraphBuilder < graph.GraphBuilder

    properties
        parallel logical
    end

    methods
        function obj = EdgeGraphBuilder()
            obj.parallel = false;
        end

        function G = buildGraph(obj, partition)
            if obj.parallel
                edges = alt_graph.parallel_find_edges(partition);
            else
                edges = alt_graph.find_edges(partition);
            end
            G = alt_graph.gen_graph(edges);
        end
    end
end

