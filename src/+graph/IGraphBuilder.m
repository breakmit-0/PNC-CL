classdef IGraphBuilder < handle
    % graph.IGraphBuilder Base class for all graph builder.
    % A graph builder is a convenience object for creating a graph
    % with the partition resulting from a lifting.

    methods (Abstract)
        G = buildGraph(obj, polyhedra)
        % Build a graph based on multiple polyhedra. Typically, these
        % polyhedra are the result of a lifting.
        % 
        % Parameters:
        %     polyhedra: column vector of Polyhedron
        %
        % Return values:
        %     G: graph
    end
end

