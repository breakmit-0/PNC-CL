function P = fast_partition(oa,ob,bbx)

    %Definition and creation of the workspace we wish to partition according 
    %to obstacles, centered at 0 and of size space_length
    [N, D] = size(oa);
    center  = zeros([1,D]);
    %bbx = util.box(center,space_length/2,space_length/2);
    
    %Creation of the polyhedral partition of the workspace according to the
    %convex lifting function
    P = repmat(Polyhedron(), N, 1);
    for i=1:N
        Ai = zeros([N, D]);
        bi = zeros([N,1]);
        for j=1:N
            Ai(j,:) = (oa(j,:) - oa(i,:))';
            bi(j) = ob(i) - ob(j);
        end
        Q = Polyhedron('A',Ai,'b',bi);
        P(i) = Q.intersect(bbx);
    end
end