function equals = matrixEquals(A, B, epsilon)
    if nargin < 3
        epsilon = 1e-5;
    end

    one = ones(size(B));
    
    equals = all((A <= B + epsilon * one) & (A >= B - epsilon * one));
end

