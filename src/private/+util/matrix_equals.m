function equals = matrix_equals(A, B, epsilon)
    % util.matrix_equals Returns true if A = B with precision epsilon
    % 
    % This function returns false if A and B don't have the same size.
    % epsilon is optional and the default value is 1e-3.
    % Two empty matrix are considered equals.
    %
    % Parameters:
    %     A: matrix
    %     B: matrix
    %     epslion: precision, optional default value is 1e-3
    %
    % Return value:
    %     equals: true if all values inside |A - B| are less or equals to
    %     epsilon. If A and B don't have the same size, it returns false.
    %

    if nargin < 3
        epsilon = 1e-3;
    end

    if any(size(A) ~= size(B))
        equals = false;
    else
        one = ones(size(B));
        
        equals = all((A <= B + epsilon * one) & (A >= B - epsilon * one), 'all');
    end
end

