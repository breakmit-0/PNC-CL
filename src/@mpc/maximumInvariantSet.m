function S = maximumInvariantSet(obj, S, Ac, N)


% Computes maximal invariant set for 
% See for more: 
% Gilbert, E. G., & Tan, K. T. (1991). Linear systems with state and control constraints: The theory and application of maximal output admissible sets. IEEE Transactions on Automatic control, 36(9), 1008-1020.


% Inputs:
%   - obj:      mpc object.
%   - S:        Given initial set.
%   - Ac:       Controlled state matrix
%   - N:        Maximum number of iterations
% Output:
%   - S:        Controlled invariant set

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

