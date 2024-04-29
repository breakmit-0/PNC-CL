
function [oa, ob, cvx] = find_iter(Obstacles, iter)
arguments
    Obstacles (:, 1) Polyhedron;
    iter (1,1) = 1;
end
    import util.*;

    min_convexity = sdpvar(1,1);

    N = size(Obstacles, 1); % nombre d'obstacles
    D = Obstacles(1).Dim; % dimension de l'espace

    a = sdpvar(N, D);
    b = sdpvar(N, 1);

    e_ab = reshape(cat(2, a, b)', [], 1);
    e = cat(1, e_ab, min_convexity);


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

    assert(i == N_constr);
    constraints = cmat * e >= 0;

    % adding a constraint to force convexity strictly positive actually makes things lees efficient
    ops = sdpsettings;
    ops.solver = "glpk";
    ops.debug = false;
    ops.verbose = false;

    constraints = [constraints; -1000 <= e <= 1000];

    [~] = optimize(constraints, -min_convexity, ops);
    iter = iter - 1;

    oa = value(a);
    ob = value(b);
    cvx = value(min_convexity);


    increaser = [repmat([repmat(1.1, 1, D) 1], 1, N) 1];

    while iter > 0
        fprintf("succes at %d with cvx = %f\n", iter, cvx);
        cmat = inc_constraints(Obstacles, N, D, cmat, 0.1);
        constraints = [cmat * e >= 0; -1000 <= e <= 1000];
        % ops.warmstart = true;
        [~] = optimize(constraints, -min_convexity, ops);

        if value(min_convexity) > 0.00001
            oa = value(a);
            ob = value(b);
            cvx = value(min_convexity);
            iter = iter - 1;
        else
            fprintf("fail at %d with cvx = %f\n", iter-1, value(min_convexity));
            break;
        end

    end

    fprintf("final at %d with cvx = %f", iter, cvx);
end


function cmat = inc_constraints(Obstacles, N, D, cmat, factor)
    i = uint32(0);

    for obs = 1:N
        bary = util.barycenter(Obstacles(obs));

        for vertex_id = 1:size(Obstacles(obs).V, 1)
            delta = Obstacles(obs).V(vertex_id, :) - bary;

            for other = 1:N
                if other ~= obs

                    i = i+1;

                    cmat(i, (D+1)*(obs-1)+1 : (D+1)*(obs-1)+D) = ...
                        cmat(i, (D+1)*(obs-1)+1 : (D+1)*(obs-1)+D) + factor * delta;
                    cmat(i, (D+1)*(other-1)+1 : (D+1)*(other-1)+D) =  ... 
                        cmat(i, (D+1)*(other-1)+1 : (D+1)*(other-1)+D) - factor * delta;

                end
            end
        end
    end
end

