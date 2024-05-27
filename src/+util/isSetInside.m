function ts = isSetInside(P1,P2)
    
    if isempty(P2.V)
        disp('P2 is empty!')
        ts = 0;
        return
    end

    tol = 1e-8;

    A = P1.A;
    b = P1.b;

    Ae = P1.Ae;
    be = P1.be;

    ts = 1;

    for j = 1:size(P2.V,1)
        x0 = P2.V(j,:);
        for i = 1:size(A,1)
            if dot(A(i,:),x0) > b(i)
                ts = 0;
                return
            end
        end
    
        for i = 1:size(Ae,1)    
            if abs(dot(Ae(i,:),x0)) - be > tol
                ts = 0;
                return
            end
        end
    end

end