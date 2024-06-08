classdef EdgeGraphBuilder < graph.IGraphBuilder
    % graph.EdgeGraphBuilder A graph builder that builds a graph based on
    % the edges of polyhedron.

    properties
        % Use MATLAB Parallel Computing Toolbox. Default: false 
        parallel logical
    end

    methods
        function obj = EdgeGraphBuilder()
            obj.parallel = false;
        end

        function G = buildGraph(obj, polyhedra)
            % It builds a graph in the following way:
            % It computes all edges of all polyhedron. All these edges
            % represent an edge in the returned graph. Two points are
            % considered equals if the norm of the difference is less than
            % an epsilon.

            import graph.EdgeGraphBuilder.*;

            if obj.parallel
                edges = parallel_find_edges(polyhedra);
            else
                edges = find_edges(polyhedra);
            end

            G = graph.edges_to_graph(edges);
        end
    end

    methods (Access=private, Static)
        
        function edge_list = find_edges(polyhedra)
            % FIND_EDGES compute all edges of polys

            edge_list = polyhedra;
            while edge_list(1).Dim - size(edge_list(1).He, 1) > 1
                edge_list = graph.flatten_facets(edge_list);
            end
        end

        function edges = parallel_find_edges(polyhedra)
            % PARALLEL_FIND_EDGES compute all edges of polyhedra but in
            % parallel

            n = height(polyhedra);
            edges_cell = cell(n);
            parfor i = 1:n
                edges_cell{i} = graph.find_edges(polyhedra(i))
            end
        
            edges = vertcat(edges_cell{:});
        end
    end
end

