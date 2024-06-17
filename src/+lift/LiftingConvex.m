
classdef LiftingConvex < Lifting
    % LiftingConvex is an implementation of Lifting
    %
    % See Also Lifting, lift, lift.LiftingLinear
    properties
        oa (:, :) double;
        ob (:, 1) double;
        diag (1, 1);
        bbox (1, 1) Polyhedron = Polyhedron();
        partition (:, 1) Polyhedron = [];
    end

    methods

        function diags = getDiagnostics(self)
            % Gets the single diagnostic for this method
            diags = self.diag;
        end


        function out = isSuccess(self)
            if ~isstruct(self.diag)
                error("cannot call isSuccess before lift.find ??")
            end

            if self.diag.problem == 0
                out = true;
            elseif self.diag.problem == 4
                warning("isSuccess: ran into numerical problems (output may still be ok)")
                out = true;
            else
                out = false;
            end
        end


        function part = getPartition(self, bbox)
            %% may be called without bbox
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
                end

                part = self.partition;
            else
                self.bbox = bbox;
                self.partition = lift.partition(self.oa, self.ob, self.bbox);
                part = self.partition;
            end
        end


        function self = LiftingConvex(Obstacles, options)
        %% Constructor and lift finding function for linear method
            arguments
                Obstacles (:, 1) Polyhedron;
                options (1, 1);
            end

            import util.*;

            if (isfield(options, "bbox"))
                self.bbox = options.bbox;
            end

            N = size(Obstacles, 1);
            D = Obstacles(1).Dim;

            min_convexity = 0.001;
            if (isfield(options, "min_cvx"))
                min_convexity = options.min_cvx;
            end

            boundedness = 0.1;
            if (isfield(options, "min_cvx"))
                boundedness = options.boundedness;
            end

            a = sdpvar(N, D);
            b = sdpvar(N, 1);
            x = reshape(cat(2, a, b)', [], 1);

            % Number of constraints to create
            N_constr = 0;
            for obs = 1:N
                N_constr = N_constr + (N) * size(Obstacles(obs).V, 1);
            end

            Aineq = zeros(N_constr, N * (D+1));
            bineq    = zeros(N_constr, 1);
            i = 0;

            for obs = 1:N

                for vertex_id = 1:size(Obstacles(obs).V, 1)
                    vertex = Obstacles(obs).V(vertex_id, :)';
                    assert_shape(vertex, [D 1]);

                    i = i+1;
                    Aineq(i, (D+1)*obs) = 1;
                    Aineq(i, (D+1)*(obs-1)+1 : (D+1)*(obs-1)+D) = vertex';
                    bineq(i) = boundedness;
                    for other = 1:N

                        if other ~= obs

                            i = i+1;

                            Aineq(i, (D+1)*obs) = -1;
                            Aineq(i, (D+1)*other) = 1;
                            Aineq(i, (D+1)*(obs-1)+1 : (D+1)*(obs-1)+D) = -vertex';
                            Aineq(i, (D+1)*(other-1)+1 : (D+1)*(other-1)+D) = vertex';

                            bineq(i) = -min_convexity;

                        end
                    end
                end
            end

            constraints = Aineq * x <= bineq;

            H = eye(N * (D + 1));
            % adding a constraint to force convexity strictly positive actually makes things less efficient
            ops = sdpsettings;
            ops.debug = false;
            ops.verbose = false;
            if (isfield(options, 'solver'))
                ops.solver = options.solver;
            end
            if( isfield(options, 'debug'))
                ops.debug = options.debug;
            end
            if( isfield(options, 'verbose'))
                ops.verbose = options.verbose;
            end
            if( isfield(options, 'sdp'))
                ops = options.sdp;
            end

            self.diag = optimize(constraints, x' * H * x, ops);
            self.oa = value(a);
            self.ob = value(b);
        end
    end
end
