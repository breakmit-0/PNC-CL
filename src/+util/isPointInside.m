function ts = isPointInside(P,x)

tol = 1e-3;

A = P.A;
b = P.b;

Ae = P.Ae;
be = P.be;

ts = [];
for i = 1:size(x,1)
    x0 = x(i,:);
    flag = 1;

    for i = 1:size(A,1)
        if dot(A(i,:),x0) > b(i)
            flag = 0;
            break
        end
    end

    for i = 1:size(Ae,1)    
        if abs(dot(Ae(i,:),x0) - be) > tol  
            flag = 0;
            break
        end
    end
    ts = [ts flag];
end

end