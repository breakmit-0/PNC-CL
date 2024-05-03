classdef EdgeGraphBuilder < graph.GraphBuilder

    methods    
        function G = buildGraph(obj, partition)
            edges = alt_graph.find_edges(partition);
            G = alt_graph.gen_graph(edges);
        end
    end
end

