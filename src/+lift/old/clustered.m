function [groups, hulls, oa_g, ob_g, cvx_g, oa, ob, cvx] = clustered(polyhedra, k, smin, smax)

    [groups, hulls] = cluster.cluster(polyhedra, k, smin, smax); 

    [oa_g, ob_g, cvx_g] = lift.find(hulls);

    disp(cvx_g);
    disp(hulls);

    if ~(cvx_g > 0.00001)
        fprintf("clustering returned non liftable clusters\n")
        return;
    end

    k = size(hulls, 1);

    args = {};
    oa = cell(k,1);
    ob = cell(k,1);
    cvx = cell(k,1);
    for i = 1:k
        args{end+1} = polyhedra(groups == i);
    end

    parfor i = 1:k
        [ra, rb, rc] = lift.find(args{i});
        disp(rc);
        oa{i} = ra;
        ob{i} = rb;
        cvx{i} = rc;
    end

end
