classdef (Abstract) Lifting < handle & matlab.mixin.Heterogeneous
    % Lifting is an interface to compute convex liftings and get a partition for a set of obstacles
    %
    % Use the constructor Lifting.find in conjunction with LiftOptions to create a lifting, then call
    % Lifting.getGraph to construct a graph
    %
    % See Also LiftOptions, lift, lift.LiftingLinear, lift.LiftingConvex, lift.LiftingCluster
    
    methods(Static)
        function self = find(obstacles, options) 
            % find is the main constructor for Lifting objects, it solves an optimization problem
            % to create a convex lifting on the set of obstacles
            % Using the linearDefault() options is recommanded
            %
            % Usage Example:
            %   lift = Lifting.find(obstacles, LiftOptions.linearDefault())
            %
            % Parameters:
            %   - obstacles : A column vector of Polyhedron objects
            %   - options : A LiftOptions object, see the documenation of that class for specifics 
            %
            % Return Value:
            %   - A Lifting object is returned, the success of the lifting operation should be checked 
            %       with the Lifting.isSucces method
            %
            % See Also Lifting, LiftOptions, lift, Lifting.isSuccess, lifting.getGraph

            arguments
                obstacles (:, 1) Polyhedron;    
                options (1, 1) LiftOptions;
            end

            switch options.strategy
                case "convex"
                    self = lift.LiftingConvex(obstacles, options);
                case "linear"
                    self = lift.LiftingLinear(obstacles, options);
                case "cluster"
                    self = lift.LiftingCluster(obstacles, options);
                otherwise
                    error("unrecognised strategy");
            end
        end
    end


    methods (Static, Sealed, Access = protected)
        function default_object = getDefaultScalarElement
            %% Required to implement heterogenous arrays
            default_object = lift.EmptyLifting;
        end
    end

    methods
        function g = getGraph(self, builder, bbox)
            % getGraph is a simplified to construct a graph from a lifting
            % Fails with an error message if the lifting is not a success
            %
            % This method should generally not be overwritten
            %
            % Usage Example:
            %   graph = lift.getGraph(graph.EdgeGraphBuilder(), work_space)
            %
            % Parameters:
            %   - self: The lifting
            %   - builder: A subclass graph.IGraphBuilder, used to specifiy how to build the graph
            %   - bbox: The space in which the graph should be contained, should be at least bigger than the 
            %       convex hull of the obstacles used to create the lifting
            %
            % Return Value:
            %   - A graph object (with some extra properties depending on the builder) is returned
            %
            % See Also lift, Lifting, graph.IGraphBuilder, graph.EdgeGraphBuilder, graph

            if ~self.isSuccess()
                fprintf("error: tried to construct a graph from a failed lifting, error output is \n")
                self.dispErrors()
            end

            P = self.getPartition(bbox);
            g = builder.buildGraph(P);
        end
    end

    methods
        function dispErrors(self)
            % dispErrors prints a clean error message to the console if lifting failed
            % overwrite if this default implementation is insufficient
            %
            % See Also Lifting
            disp(self.getDiagnostics());
        end
    end

    methods % (Abstract)
        function part = getPartition(self, bbox)
            % (abstract) getPartition queries the result of the lifting 
            % in the form of a partition of the space
            % the method should also memoize the result and allow
            % calling without the bbox argument to
            % query the memoized result
            %
            % This method should be considered Abstract and always be overwritten
            %
            % Parameters:
            %   - self: The lfitng
            %   - bbox: if provided th bounding box as explained in getGraph, if not,a  memoized result is queried
            %
            % Return Value:
            %   A Column vector of Polyhedron is returned
            %   if bbox is not provided and no memoized result exists, an error message is returned
            %
            % See Also Lifting, lift, Polyhedron, Lifting.getGraph


            error("this subclass does not overwrite getPartition")
        end

        function diag = getDiagnostics(self)
            % (abstract) getDiagnostics queries optimizer results
            % generally used by Lifting.isSuccess
            %
            % This method should be considered abstract
            %
            % Return Value:
            %  Any type may be returned by this method
            %
            % See Also Lifting, lift

            error("this subclass does not overwrite getDiagnostic")
        end

        function res = isSuccess(self)
            % (abstract) isSuccess returns true if the lifting was succcessful
            %
            % See Also Lifting, lift

            error("this subclass does not overwrite isSuccess")
        end
    end
end
