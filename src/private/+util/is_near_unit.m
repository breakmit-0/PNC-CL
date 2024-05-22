function res = is_near_unit(test, epsilon)
    % util.is_near_unit Checks wether a vector is within an epsilon of beeing colinear with a unit vector
    %
    % Usage:
    %   r = is_near_unit(vec, epsilon)      
    %   r = is_near_unit(vec)               uses a default epsilon
    %
    % Parameters:
    %   vec is a row vector
    %   epsilon (optional) is a scalar
    %
    % Return Value:
    %   A boolean is returned
    %
    % The specific formula used is N(vec - N(vec)*u) <= N(vec)*epsilon where N is the euclidian norm and u is a unit vector
    %
    % See also util

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
