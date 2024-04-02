function equals = matrix_equals(A, B, epsilon)
    % EQUALS Returns true if A = B with precision epsilon
    % 
    % This function returns false if A and B don't have the same size.
    % epsilon is optional and the default value is 1e-3.

    if nargin < 3
        epsilon = 1e-3;
    end

    if any(size(A) ~= size(B))
        equals = false;
    else
        one = ones(size(B));
        
        equals = all((A <= B + epsilon * one) & (A >= B - epsilon * one));
    end
end

