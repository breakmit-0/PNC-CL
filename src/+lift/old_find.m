
function [oa, ob] = find(Obstacles)
    % lift.find The main function to compute a convex lifting for an array of obstacles [<a href="matlab:web('https://breakmit-0.github.io/lift-ppl/')">online docs</a>]
    % 
    %
    % Usage:
    %   [oa, ob] = lift.find(obstacles)
    %
    % Parameters:
    %   obstacles should be a column vector of non intersecting, same dimensional Polyhedron objects
    %   some outputs may be redundant if there are intersections
    %
    % Return Values:
    %   ob is a column vector of dimension N
    %   oa is a matrix of dimension NxD where D is the dimension of the obestacles
    %
    %   the outputs are such that z = max(oa * x + ob) is the convex lifting function
    %   
    %   the row k of the output is guaranteeed to be the plane around the obstacle at index k
    %
    % See also lift

    import util.*;

    min_convexity = 1;
    upper_bound = 500;

    N = size(Obstacles, 1); % nombre d'obstacles
    D = Obstacles(1).Dim; % dimension de l'espace
   

    a = sdpvar(N, D);
    b = sdpvar(N, 1);

    constraints = [];

    for obs = 1:N
        for vertex_id = 1:size(Obstacles(obs).V, 1)
            vertex = Obstacles(obs).V(vertex_id, :)';
            assert_shape(vertex, [D 1]);
            for other = 1:N
                if other ~= obs
                    constraints = [constraints; mtimes(a(obs,:),vertex) + b(obs) >= mtimes(a(other,:), vertex) + b(other) + min_convexity];
                end
            end
        end
        constraints = [constraints; mtimes(a(obs,:), Obstacles(obs).V(1, :)') + b(obs) <= upper_bound];
        % constraints = [constraints; mtimes(a(obs,:), Obstacles(obs).V(1, :)') + b(obs) >= 0]; 
    end

    e = cat(2, a, b);
    optimize(constraints, norm(e, 2));
    oa = value(a);
    ob = value(b);
end
