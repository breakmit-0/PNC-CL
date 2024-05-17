
classdef LiftingCluster < Lifting
    properties
        hulls (:, 1) Polyhedron;
        groups (:, 1) uint32;
        meta (1, 1) lift.Lifting;
        children (:, 1) Lifting;
        partition (:, 1) = [];
    end

    methods
        function diags = getDiagnostics(self)
            diags.self = self.meta.getDiagnostics();
            diags.child = self.children.getDiagnostics();
        end

        function part = getPartition(self, bbox)

        end

        function succ = isSuccess(self)
            if ~self.meta.isSuccess()
                succ = false;
                return;
            end
            for i = 1:size(self.children, 1)
                if ~self.children(i).isSuccess()
                    succ = false;
                    return;
                end
            end
            succ = true;
        end


        
        function self = LiftingCluster(obstacles, options)
            arguments
                obstacles (:, 1) Polyhedron;
                options (1, 1) struct;
            end

            k = 5;
            if (isfield(options, "cluster_count"))
                k = options.cluster_count;
            end
            
            [g, h] = list.cluster(obstacles, k, options.space_min, options.space_max);
            self.hulls = h;
            self.goups = g;

            meta_opts = options;
            meta_opts.strategy = options.fallback;
            self.meta = Lifting(self.hulls, meta_opts);


            if (~self.meta.isSuccess())
                if (isfield(options, "debug") && options.debug)
                    fprintf("clustering was not liftable, using fallback instead\n");
                end
                error("fallback not yet implemented");
                % return
            end


            child_opts = options;
            if (isfield(child_opts, "depth") && child_opts.depth > 0)
                child_opts.depth = child_opts.depth - 1;
            else
                child_opts.startegy = options.fallback;
            end

            real_count = size(hulls, 1);
            c(1:real_count) = Lifting(); 

            args{1:real_count} = [];
            for i = 1:real_count
                args{i} = obstacles(self.groups == i);
            end

            parfor i = 1:real_count
                c(i) = Lifting(args{i} ,child_opts)          
            end

            self.children = c;
        end
    end
end
