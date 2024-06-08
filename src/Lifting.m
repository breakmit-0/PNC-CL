classdef (Abstract) Lifting < handle & matlab.mixin.Heterogeneous
    %% An interface for the output of convex lifting, the possible options are
    % See LiftingOptions
    
    methods(Static)
        function self = find(obstacles, options) 
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
            default_object = lift.EmptyLifting;
        end
    end

    methods
        function g = getGraph(self, builder, bbox)

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
            disp(self.getDiagnostics());
        end
    end

    methods (Abstract)
        getPartition(self, bbox);
        getDiagnostics(self);
        isSuccess(self);
    end
end
