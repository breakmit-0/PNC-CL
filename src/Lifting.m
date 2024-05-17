classdef (Abstract) Lifting
    %% An interface for the output of convex lifting

    methods(Static)
        function self = find(obstacles, options) 
            if nargin > 1 && isfield(options, "strategy")
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
                return;
            end
            if nargin > 0
                self = lift.LiftingLinear(obstacles, struct());
            end
        end
    end
    methods (Abstract)
        getPartition(self, bbox);
        getDiagnostics(self);
        isSuccess(self);
    end
end
