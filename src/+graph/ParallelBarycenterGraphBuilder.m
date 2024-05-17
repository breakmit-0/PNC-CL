classdef ParallelBarycenterGraphBuilder < graph.BarycenterGraphBuilder 

    methods
        function G = buildGraph(obj, src, dest, obstacles, partition)
            import graph.BarycenterGraphBuilder.*;

            n = height(partition);
            edges_cell = cell(n, 1);
            parfor i = 1:n
                p = partition(i);
                p.minHRep();
                facets = p.getFacet();
                subFacets = graph.flatten_facets(facets);
                edges_cell{i} = createEdges(p, facets, subFacets)
            end

            edges = vertcat(edges_cell{:});
            G = graph.edges_to_graph(edges);
        end
    end
end
