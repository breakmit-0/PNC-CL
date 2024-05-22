classdef EdgeGraphBuilder < graph.IGraphBuilder

    properties
        parallel logical
    end

    methods
        function obj = EdgeGraphBuilder()
            obj.parallel = false;
        end

        function G = buildGraph(obj, partition)
            if obj.parallel
                edges = graph.parallel_find_edges(partition);
            else
                edges = graph.find_edges(partition);
            end
            G = graph.edges_to_graph(edges);
        end
    end
end

