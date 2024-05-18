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
            import graph.BarycenterGraphBuilder.*;

            n = height(subFacets);
            edges = repmat(Polyhedron(), n, 1);
            edgeI = 1; % index of the edge (also the index of the sub facet)
            facetI = 1; % index of the facet

            centers = pre_allocate_barycenters(partition, facets);

            % iterator over all partitions
            for p = partition.'
                fiEnd = facetI + height(p.H);

                % iterator over all facets of the polyhedron
                while facetI < fiEnd
                    f = facets(facetI);
                    numSubFacet = height(f.H);

                    edgeIEnd = edgeI + numSubFacet;
                    edgeICopy = edgeI;
                    centerI = 1;

                    % iterate over the subfacets
                    % compute all barycenters
                    while edgeI < edgeIEnd
                        centers(centerI, :) = barycenter_of_edge(subFacets(edgeI));
                        edgeI = edgeI + 1;
                        centerI = centerI + 1;
                    end

                    % compute the barycenter of the facet
                    center = sum(centers(1:numSubFacet, :)) / numSubFacet; 

                    % iterate over the subfacets and add the edge
                    edgeI = edgeICopy;
                    centerI = 1;
                    while edgeI < edgeIEnd
                        edges(edgeI) = Polyhedron('V', [center; centers(centerI, :)]);
                        edgeI = edgeI + 1;
                        centerI = centerI + 1;
                    end

                    facetI = facetI + 1;
                end
            end
        end

        function centers = pre_allocate_barycenters(partition, facets)
            fi = 1;
            size = 0;

            for p = partition.'
                fiEnd = fi + height(p.H);
                
                while fi < fiEnd
                    size = max(size, height(facets(fi).H));
                    fi = fi + 1;
                end
            end

            centers = zeros(size, partition(1).Dim);
        end

        function center = barycenter_of_edge(edge)
            if height(edge.A) == 2
                V1 = [edge.Ae; edge.A(1, :)] \ [edge.be; edge.b(1,:)];
                V2 = [edge.Ae; edge.A(2, :)] \ [edge.be; edge.b(2,:)];

                center = ((V1 + V2) / 2).';
            else
                V1 = [];

                for i = 1:height(edge.A)
                    V = [edge.Ae; edge.A(i, :)] \ [edge.be; edge.b(i,:)];

                    if ~anynan(V) && all(V ~= inf) && edge.contains(V)
                        if isempty(V1)
                            V1 = V;
                        else
                            center = ((V1 + V) / 2).';
                            return
                        end
                    end
                end

                disp("fail")
                center = graph.util.barycenter(edge);
            end
        end
    end
end
