function Np = backwardsReachableSet(obj, P, R, x0)

% Computes Backward Reachable Set and Returns number of prediction 
% necessary to fulfill recursive feasability.

% Notes: 
%       - Computation might be complex and time consuming 
%         if the given R is complex
%       - Check ref
%           Konyalıoğlu, T., Olaru, S., Niculescu, S. I., Ballesteros-Tolosana, 
%           I., & Mustaki, S. (2024, August). On corridor enlargement for MPC-based 
%           navigation in cluttered environments. In NMPC 2024-8th IFAC Conference 
%           on Nonlinear Model Predictive Control.

% Inputs:
%   - obj:      mpc object.
%   - P:        the set to be reached in state space.
%   - R:        initial set to start the computation in output space.
%   - x0:       The initial state vector.
%
% Output:
%   - Np:       Number of prediction


    BU = Polyhedron((obj.BBRS*obj.U.V')');
    Np = 1;


    while Np < 200
        Vtmp = util.minkowskiSum((inv(obj.ABRS) * R.V')', (inv(obj.ABRS) * -BU.V')');
        Ptmp = cddmex('reduce_v',struct('V', Vtmp));
        R = Polyhedron(double(Ptmp.V));
        Np = Np + 1;
        Rp = projection(R,1:obj.ny);
        if  all(util.isPointInside(Rp,P.V)) && util.isPointInside(Rp,(obj.C * x0)')
            break
        end
    end
    Np = ceil( Np * obj.settings.backwards_reachability_scaler );
end