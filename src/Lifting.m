classdef (Abstract) Lifting
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

    methods
        function getGraph(self, options)
            p = self.getPartition(options.bbox);
            
        end
    end

    methods (Abstract)
        getPartition(self, bbox);
        getDiagnostics(self);
        isSuccess(self);
    end
end
