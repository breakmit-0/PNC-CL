function maxv = max(oa, ob, space)
    % lift.max  Finds the maximum of a convex lifting on a given space
    %
    % Usage:
    %   m = lift.max(oa, ob, space_size)
    %
    % Parameters:
    %   oa and ob are the values returned by lift.find 
    %   space_size defines where to search for a maximum
    %
    % Return Value:
    %   the function returns the maximum of the function on [0, space_size]^D where D is the dimension of oa and ob
    %
    % See also lift, lift.find

    [N, ~] = size(oa);
    maxv = ob(1);

    for i = 1:N
        v = ob(i);
        maxv = max(maxv, v);
        v = ob(i) + space * oa(i, 1);
        maxv = max(maxv, v);
        v = ob(i) + space * oa(i, 2);
        maxv = max(maxv, v);
        v = ob(i) + space *(oa(i,1) + oa(i, 2));
        maxv = max(maxv, v);
    end
end
