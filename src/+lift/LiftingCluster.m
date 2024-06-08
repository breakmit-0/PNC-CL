
classdef LiftingCluster < Lifting
    properties
        hulls (:, 1) Polyhedron;
        groups (:, 1) uint32;
        meta (1, 1) Lifting = lift.EmptyLifting;
        children (:, 1) Lifting;
        bbox (1, 1) Polyhedron;
        partition (:, 1) = [];
    end

    methods
        function diags = getDiagnostics(self)
            diags.self = self.meta.getDiagnostics();
            diags.child = self.children.getDiagnostics();
        end

        function part = getPartition(self, bbox)

            if ~self.isSuccess()
                error("cannot get partition for failed lifting")
            end

            if nargin < 2
                bbox = Polyhedron();
            end
            
            if bbox.Dim == 0
                if self.bbox.Dim == 0
                    error("cannot query the stored partition as it does not exist (provide a bbox)")
                end

                if size(self.partition, 1) == 0
                    self.partition = lift.partition(self.oa, self.ob, self.bbox);
                else
                    part = self.partition;
                    return;
                end

            else
                self.bbox = bbox;
            end


            meta_hulls = self.meta.getPartition(bbox);
            self.partition = [];
            
            for i = 1:size(self.children, 1)
                local = self.children(i).getPartition(meta_hulls(i));

                for j = 1:size(local, 1)
                    self.partition = [self.partition; meta_hulls(i).and(local(j))];
                end
            end

            part = self.partition;
        end

        function succ = isSuccess(self)
            if ~self.meta.isSuccess()
                succ = false;
                return;
            end
            for i = 1:size(self.children, 1)
                if ~self.children(i).isSuccess()
                    succ = false;
                    disp("failed due to child")
                    return;
                end
            end
            succ = true;
        end

        function dispErrors(self)

            if ~self.meta.isSuccess()
                fprintf("failed because of meta lifting :\n");
                self.meta.getErrors();
            end

            for i = 1:size(self.children, 1)
                if ~self.children(i).isSuccess()
                    fprintf("failed because of child %d :\n", i)
                    self.children(i).dispErrors();
                end
            end
        end


        
        function self = LiftingCluster(obstacles, options)
            arguments
                obstacles (:, 1) Polyhedron;
                options (1, 1) LiftOptions;
            end

            k = 5;
            if (isfield(options, "cluster_count"))
                k = options.cluster_count;
            end

            total_hull = PolyUnion(obstacles).convexHull();
            total_hull = total_hull.minVRep;
            space_min = min(total_hull.V, [], 1);
            space_max = max(total_hull.V, [], 1);
            
            [g, h] = lift.cluster(obstacles, k, space_min, space_max);
            self.hulls = h;
            self.groups = g;

            meta_opts = options;
            meta_opts.strategy = options.fallback;
            self.meta = Lifting.find(self.hulls, meta_opts);


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
                child_opts.strategy = options.fallback;
            end

            real_count = size(self.hulls, 1);
            c = cell(real_count); 
            args = cell(real_count);

            for i = 1:real_count
                args{i} = obstacles(self.groups == i);
            end

            for i = 1:real_count
                c{i} = Lifting.find(args{i} ,child_opts);         
            end
            
            for i = 1:real_count
                self.children(i) = c{i};
            end

        end
    end
end
