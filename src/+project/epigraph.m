function out = epigraph(oa, ob, space)
    [N, D] = size(oa);

    A = cat(2, oa, -ones(N, 1));
    P = Polyhedron(A, -ob); 
    P.minHRep();

    bbx = util.box(space/2*ones(1,D+1), space/2, lift.max(oa,ob,space));
    
    out = P.intersect(bbx);
    out.minHRep();
  end
