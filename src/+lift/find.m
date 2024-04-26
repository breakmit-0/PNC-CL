
function [oa, ob] = new_find(Obstacles)
    import util.*;

    min_convexity = sdpvar(1,1);
    upper_bound = 500;

    N = size(Obstacles, 1); % nombre d'obstacles
    D = Obstacles(1).Dim; % dimension de l'espace
    

    a = sdpvar(N, D);
    b = sdpvar(N, 1);

    %constraints = [];
    constraints = [];

    for obs = 1:N
        bc = util.barycenter(Obstacles(obs));

        for vertex_id = 1:size(Obstacles(obs).V, 1)
            vertex = Obstacles(obs).V(vertex_id, :)';

            assert_shape(vertex, [D 1]);
            for other = 1:N
                if other ~= obs
                    constraints = [constraints; mtimes(a(obs,:),vertex) + b(obs) >= mtimes(a(other,:), vertex) + b(other) + min_convexity];
                end
            end
        end
    end

    disp("optimizing now");

    e = cat(2, a, b);
    opt = sdpsettings();
    diag = solvesdp(constraints, -min_convexity, []);
  
    disp(diag);
    fprintf("convexity = %d", value(min_convexity));

    % disp(diag);
    %
    % disp(value(a));
    % disp(value(b));
    % disp(value(min_convexity));

    %optimize(constraints, norm(b) + norm(a));
    oa = value(a);
    ob = value(b);
    % os = value(s);
end
