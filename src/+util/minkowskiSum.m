function SV = minkowskiSum(P1, P2)

dim = size(P1,2);

n1 = size(P1);
n2 = size(P2);

SV = reshape(P1, [1, n1]) + reshape(P2, [n2(1), 1, n2(2)]);
SV = reshape(SV, [], dim);


end