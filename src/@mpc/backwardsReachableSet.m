function Np = backwardsReachableSet(obj, P, R, x0)

    BU = Polyhedron((obj.B*obj.U.V')');
    Np = 1;

    while Np < 200
        Vtmp = util.minkowskiSum((inv(obj.A) * R.V')', (inv(obj.A) * -BU.V')');
        Ptmp = cddmex('reduce_v',struct('V', Vtmp));
        R = Polyhedron(double(Ptmp.V));
        Np = Np + 1;
        Rp = projection(R,1:obj.ny);
        if  all(util.isPointInside(Rp,P.V)) && util.isPointInside(Rp,(obj.C * x0)')
            break
        end
    end
end