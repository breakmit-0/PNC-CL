% check if a vector is within an epsilon of any unit vector
function res = is_near_unit(test, epsilon)
    arguments
        test;
        epsilon = 0.01;
    end

    D = size(test);
    D = D(2);

    r = norm(test);
   
    for i = 1:D
        u = util.unit_vec(D,i);
        res = norm(test - r*u) <= r*epsilon;
        if res
            return
        end
        res = norm(r*u + test) <= r*epsilon;
        if res
            return
        end
    end
end
