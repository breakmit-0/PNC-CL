classdef (Abstract) Lifting
    %% An interface for the output of convex lifting, the possible options are
    %   sdp (1, 1) struct                   % override sdpsettings for optimizer
    %   debug (1, 1) locical = false        % enable debug mode
    %   verbose (1, 1) logical = false      % enable verbose mode
    %   strategy (1, 1) string = "linear"   % the lifting strategy to use
    %   cluster_count (1, 1) uint32 = 5     % for cluster strategy, how may clusters to create
    %   depth (1, 1) uint32 = 0             % for cluster strategy, how many steps until fallback
    %   fallback (1, 1) string = "linear"   % the end strategy for clustering, "cluster" WILL create an infinite loop
    %   min_cvx (1, 1) double = 0.001       % the minimum convexity for the convex strategy

    methods(Static)
        function self = find(obstacles, options) 
        arguments
            obstacles (:, 1) Polyhedron;    
            options (1, 1) struct;
        end
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
