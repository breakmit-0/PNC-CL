function P = partition(oa,ob,bbx)

    %Definition and creation of the workspace we wish to partition according 
    %to obstacles, centered at 0 and of size space_length
    [N, D] = size(oa);
    
    %Creation of the polyhedral partition of the workspace according to the
    %convex lifting function
    P = repmat(Polyhedron(), N, 1);
    for i=1:N
        Ai = zeros([N - 1, D]);
        bi = zeros([N - 1, 1]);
        offset = 0;
        for j=1:N
            if i ~= j
                Ai(j - offset, :) = (oa(j, :) - oa(i, :))';
                bi(j - offset) = ob(i) - ob(j);
            else
                offset = 1;
            end
        end
        Q = Polyhedron('A',Ai,'b',bi);
        P(i) = Q.intersect(bbx);
    end
end
