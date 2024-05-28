function S = controlInvariant(obj, A, varargin)


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