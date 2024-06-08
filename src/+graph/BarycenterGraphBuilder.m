classdef BarycenterGraphBuilder < graph.IGraphBuilder
    % graph.BarycenterGraphBuilder Build a graph based on the barycenter of
    % the facets and sub facets of all polyhedra.

    properties
        % Use MATLAB Parallel Computing Toolbox. Default: false 
        parallel logical
    end

    methods
        function G = buildGraph(obj, polyhedra)
            % Builds a graph using the barycenter of the facets and sub
            % facets of all polyhedra. It works in the following way:
            % 1. For all facets, compute the barycenter of the sub facets
            % 2. The barycenter of the facet can be deduced from the 
            % average of the barycenter of the sub facets.
            % 3. The barycenter is linked to every barycenter of sub
            % facets.

            import graph.BarycenterGraphBuilder.*;

            if obj.parallel
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
                
            else
                facets = graph.flatten_facets(polyhedra);
                subFacets = graph.flatten_facets(facets);

                edges = createEdges(polyhedra, facets, subFacets);
            end

            G = graph.edges_to_graph(edges);
        end
    end

    methods (Access=protected, Static)
        function edges = createEdges(partition, facets, subFacets)
            % iterate over all partitions,
            % then iterate over all facets of the partition,
            % then iterate over all edges of facets,
            % then compute the barycenter of an edge and save the result in
            % 'centers',
            % then compute the barycenter of the facet by computing the
            % average of the just calculated barycenter,
            % finally for each edge, create an edge from the barycenter of
            % the edge to the barycenter of the facet.

            import util.barycenter;
            import graph.BarycenterGraphBuilder.*;

            n = height(subFacets);
            edges = repmat(Polyhedron(), n, 1);
            edgeI = 1; % index of the edge (also the index of the sub facet)
            facetI = 1; % index of the facet
            
            if partition(1).Dim == 3
                barycenter_func = @(edge) barycenter_of_edge(edge);
            else
                barycenter_func = @(edge) barycenter(edge);
            end

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
                        centers(centerI, :) = barycenter_func(subFacets(edgeI));
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

        function centers = pre_allocate_barycenters(polyhedra, facets)
            % Parameters:
            %     polyhedra: polyhedra
            %     facets: facets of all polyhedra
            %
            % Return value:
            %     centers: an array that can contains all barycenter of sub
            %     facets of a facet

            fi = 1;
            size = 0;

            for p = polyhedra.'
                fiEnd = fi + height(p.H);
                
                while fi < fiEnd
                    size = max(size, height(facets(fi).H));
                    fi = fi + 1;
                end
            end

            centers = zeros(size, polyhedra(1).Dim);
        end

        function center = barycenter_of_edge(edge)
            % BARYCENTER_OF_EDGE compute the barycenter of edge

            V = graph.fast_vertices_of_edge(edge);

            center = (V(1, :) + V(2, :)) / 2;
        end
    end
end
