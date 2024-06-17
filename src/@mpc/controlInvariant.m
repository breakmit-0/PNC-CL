function S = controlInvariant(obj, A, varargin)

% Computes controlled invariant set for given possible pairs:
% (A,X) - (C,Y) - (K,U)
% See for more: Blanchini, F. (1999). Set invariance in control. Automatica, 35(11), 1747-1767.


% Inputs:
%   - obj:      mpc object.
%   - A:        State matrix (Required) (must be controlled if K is not input).
%   - C:        Output matrix (Optional with Y).
%   - K:        Control feedback gain (Optional with U).
%   - X:        State constraint set (Optional)
%   - Y:        Output constraint set (Optional with C).
%   - U:        Control admissible set (Optional with K).
%   - N:        Maximum number of iterations (Optional)

%   
%
% Output:
%   - S:        Controlled invariant set


S = Polyhedron;

defaultN = 100;
defaultMatrix = [];
defaultPolyhedron = Polyhedron;



p = inputParser;
validNum = @(x) isnumeric(x);
validScalar = @(x) isscalar(x);
validPolyhedron = @(x) isa( x, 'Polyhedron' );
addOptional(p,'N',defaultN,validNum);
addRequired(p,'A',validNum);
addOptional(p,'C',defaultMatrix,validNum);
addOptional(p,'K',defaultMatrix,validNum);
addOptional(p,'X',defaultPolyhedron,validPolyhedron);
addOptional(p,'Y',defaultPolyhedron,validPolyhedron);
addOptional(p,'U',defaultPolyhedron,validPolyhedron);


parse(p, A, varargin{:});
d = p.Results;


H = [];
w = [];

Hx = d.X.A;
Hy = d.Y.A;
Hu = d.U.A;

wx = d.X.b;
wy = d.Y.b;
wu = d.U.b;

H = [ Hx; Hy * d.C; Hu * d.K ];
w = [wx; wy; wu];

O = Polyhedron(H,w);

if isempty(H) || isempty(w) %|| ~isBounded(O)
    error('it should be bounded')
end

S = obj.maximumInvariantSet(O, d.A, d.N);

% S = maximumInvariantSet(setBasisOnes(O), d.A, d.N);


end