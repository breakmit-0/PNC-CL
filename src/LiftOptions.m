   
classdef LiftOptions
    % The argument passed to Lifting
    %
    % Construct with the deault constrctor or any of the static methods
    %
    % See Also Lifting,

    properties
        sdp (1, 1) struct = sdpsettings();   % override sdpsettings for optimizer
        debug (1, 1) logical = false;        % enable debug mode
        verbose (1, 1) logical = false;      % enable verbose mode
        strategy (1, 1) string = "linear";   % the lifting strategy to use
        cluster_count (1, 1) uint32 = 5;     % for cluster strategy, how may clusters to create
        depth (1, 1) uint32 = 0;             % for cluster strategy, how many steps until fallback
        fallback (1, 1) string = "linear";   % the end strategy for clustering, "cluster" WILL create an infinite loop
        min_cvx (1, 1) double = 0.001;       % the minimum convexity for the convex strategy
        solver (1, 1) string = "";           % override the solver only
    end

    methods (Static)
        function opts = linearDefault()
            % Default settings with "linear" method
            opts = LiftOptions();
            opts.strategy = "linear";
            opts.debug = true;
            opts.verbose = true;
        end

        function opts = convexDefault()
            % Default settings with "convex" method
            opts = LiftOptions();
            opts.strategy = "convex";
            opts.debug = false;
            opts.verbose = false;
            opts.min_cvx = 0.001;
        end

        function opts = clusterDefault()
            % Default settings with "cluster" method (not recommended)
            opts = LiftOptions();
            opts.debug = false;
            opts.verbose = false;
            opts.strategy = "cluster";
            opts.fallback = "linear";
            opts.cluster_count = 5;
            opts.depth = 0;
        end
    end

end


