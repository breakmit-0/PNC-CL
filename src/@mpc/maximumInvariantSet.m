function S = maximumInvariantSet(obj, S, Ac, N)

H = S.A;
w = S.b;

counter = 1;
while counter < N

    Hp=struct('A',[S.A;H*(Ac^counter)],'B',[S.b;w]);
    s = cddmex('reduce_h', Hp);
    Stmp = Polyhedron('A',s.A,'B',s.B);

    counter = counter + 1;
    if util.isSameSet(S,Stmp)
        S = Stmp;
        break
    else
        S = Stmp;

    end
end
end

