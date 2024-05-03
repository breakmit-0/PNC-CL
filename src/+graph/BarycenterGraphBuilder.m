classdef BarycenterGraphBuilder < graph.GraphBuilder 

    methods
        function G = buildGraph(obj, partition)
            import graph.BarycenterGraphBuilder.*;

            facets = alt_graph.flatten_facets(partition);
            subFacets = alt_graph.flatten_facets(facets);

            edges = createEdges(partition, facets, subFacets);
            G = alt_graph.gen_graph(edges);
        end
    end

    methods (Access=private, Static)
        function edges = createEdges(partition, facets, subFacets)
            import util.barycenter;

            n = height(subFacets);
            edges = repmat(Polyhedron(), n, 1);
            i = 1; % index of the edge (also the index of the sub facet
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
