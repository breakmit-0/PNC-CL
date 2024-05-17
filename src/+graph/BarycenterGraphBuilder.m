classdef BarycenterGraphBuilder < graph.IGraphBuilder 

    methods
        function G = buildGraph(obj, src, dest, obstacles, partition)
            import graph.BarycenterGraphBuilder.*;

            facets = graph.flatten_facets(partition);
            subFacets = graph.flatten_facets(facets);

            edges = createEdges(partition, facets, subFacets);
            G = graph.edges_to_graph(edges);
        end
    end

    methods (Access=protected, Static)
        function edges = createEdges(partition, facets, subFacets)
            import util.barycenter;

            n = height(subFacets);
            edges = repmat(Polyhedron(), n, 1);
            i = 1; % index of the edge (also the index of the sub facet)
            fi = 1; % index of the facet

            for p = partition.'
                fiEnd = fi + height(p.H);

                while fi < fiEnd
                    f = facets(fi);
                    center = util.barycenter(f);
                    numSubFacet = height(f.H);

                    iEnd = i + numSubFacet;
                    while i < iEnd
                        subCenter = barycenter(subFacets(i));
                        edges(i) = Polyhedron('V', [center; subCenter]);

                        i = i + 1;
                    end

                    fi = fi + 1;
                end
            end
        end
    end
end
