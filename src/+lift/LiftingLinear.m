classdef LiftingLinear < Lifting
    properties
        oa (:, :) double;
        ob (:, 1) double;
        cvx (1, 1) double;
        diag (1, 1);
        bbox (1, 1) Polyhedron = Polyhedron();
        partition (:, 1) Polyhedron = [];
    end

    methods

        function diags = getDiagnostics(self)
            %% Gets the single diagnostic for this method
            diags = self.diag;
        end

        function out = isSuccess(self)
            %% Success is achieved if the minimal convexity is greater than 0
            out = (self.cvx > 0);
        end

        function [part] = getPartition(self, bbox)
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

        function self = LiftingLinear(Obstacles, options)
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

            min_convexity = sdpvar(1,1);
            a = sdpvar(N, D);
            b = sdpvar(N, 1);

            e_ab = reshape(cat(2, a, b)', [], 1);
            e = cat(1, e_ab, min_convexity);


            % Number of constraints to create
            N_constr = 0;
            for obs = 1:N
                N_constr = N_constr + (N-1) * size(Obstacles(obs).V, 1);
            end

            cmat = zeros(N_constr, N * (D+1) + 1);
            i = 0;

            for obs = 1:N

                for vertex_id = 1:size(Obstacles(obs).V, 1)
                    vertex = Obstacles(obs).V(vertex_id, :)';

                    assert_shape(vertex, [D 1]);
                    for other = 1:N
                        if other ~= obs

                            i = i+1;

                            cmat(i, (D+1)*obs) = 1;
                            cmat(i, (D+1)*other) = -1;
                            cmat(i, (D+1)*(obs-1)+1 : (D+1)*(obs-1)+D) = vertex';
                            cmat(i, (D+1)*(other-1)+1 : (D+1)*(other-1)+D) = -vertex';
                            cmat(i, (D+1) * N + 1) = -1;

                        end
                    end
                end
            end

            constraints = cmat * e >= 0;
            constraints = [constraints; -1000 <= e <= 1000];

            % adding a constraint to force convexity strictly positive actually makes things lees efficient
            ops = options.sdp;
            ops.debug = options.debug;
            ops.verbose = options.verbose;
            ops.solver = "glpk";

            self.diag = optimize(constraints, -min_convexity, ops);
            self.oa = value(a);
            self.ob = value(b);
            self.cvx = value(min_convexity);

            if ~(self.cvx > 1e-6)
                self.cvx = -1; % put an arbirary min bound on convexity
            end
        end
    end
end
