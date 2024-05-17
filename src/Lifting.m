classdef (Abstract) Lifting

    methods
        function self = Lifting(obstacles, options) 
            if nargin > 0
                switch options.strategy
                    case "convex"
                        self = lift.LiftingConvex(obstacles, options);
                    case "linear"
                        self = lift.LiftingLinear(obstacles, options);
                    case "cluster"
                        self = lift.LiftingCluster(obstacles, options);
                    otherwise
                        error("Bad lifting strategy");
                end
            end
        end
    end
    methods (Abstract)
        getPartition(self, bbox);
        getDiagnostics(self);
        isSuccess(self);
    end
end
