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
            % Fast methods to compute the barycenter of an edge in 3D.
            % https://or.stackexchange.com/questions/4540/how-to-find-all-vertices-of-a-polyhedron/4541#4541

            if height(edge.A) == 2
                V1 = linsolve([edge.Ae; edge.A(1, :)], [edge.be; edge.b(1,:)]);
                V2 = linsolve([edge.Ae; edge.A(2, :)], [edge.be; edge.b(2,:)]);

                center = ((V1 + V2) / 2).';
            else
                V1 = [];

                for i = 1:height(edge.A)
                    [V, ~] = linsolve([edge.Ae; edge.A(i, :)], [edge.be; edge.b(i,:)]);

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
                center = util.barycenter(edge);
            end
        end
    end
end
