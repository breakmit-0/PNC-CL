% find the maximum of the lifting on [0;space]^D
function maxv = max(oa, ob, space)
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
