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

            if obj.parallel
                edges = graph.parallel_find_edges(polyhedra);
            else
                edges = graph.find_edges(polyhedra);
            end

            G = graph.edges_to_graph(edges);
        end
    end
end

