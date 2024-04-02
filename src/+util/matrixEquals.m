function equals = matrixEquals(A, B, epsilon)
    % EQUALS Returns true if A = B with precision epsilon
    % 
    % Parameters:
    % A: matrix of dim n x m
    % B: matrix of dim n x m
    % epsilon: precision

    if nargin < 3
        epsilon = 1e-3;
    end

    one = ones(size(B));
    
    equals = all((A <= B + epsilon * one) & (A >= B - epsilon * one));
end

