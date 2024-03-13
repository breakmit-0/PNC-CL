function check_constraints(Obstacles, oa, ob)
    min_convexity = 1;
    upper_bound = 100;

    N = size(Obstacles, 1); % nombre d'obstacles

    t = 0;
    s = 0;

    t2 = 0;
    s2 = 0;

    for obs = 1:N
        for vertex_id = 1:size(Obstacles(obs).V, 1)
            vertex = Obstacles(obs).V(vertex_id)';
            for other = 1:N
                if other ~= obs
                    t = t + 1;
                    if mtimes(oa(obs,:), vertex) + ob(obs) >= mtimes(oa(other,:), vertex) + ob(other) + min_convexity
                        s = s + 1;
                    end
                end
            end
        end
        
        t2 = t2 + 2;
        v = mtimes(oa(obs,:), Obstacles(obs).V(1,:)') + ob(obs);
        if v <= upper_bound
            s2 = s2 + 1;
        end
        if v >= 0
            s2 = s2 + 1;
        end


        % constraints = [constraints; mtimes(a(obs,:), Obstacles(obs).V(1, :)') + b(obs) >= 0]; 
    end

    fprintf("convexity succes rate = %d%% (%d/%d)\n", round(100*s/t), s, t);
    fprintf("boundedness succes rate = %d%% (%d/%d)\n", round(100*s2/t2), s2, t2);
end
