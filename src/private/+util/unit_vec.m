function v = unit_vec(dim, n)
    % util.unit_vec Creates a unit vector
    %
    % Usage:
    %   u = util.unit_vec(dim, n)
    %
    % Parameters:
    %   dim is an integer, the dimension on the vector
    %   n is an integer with (1 <= n <= dim)
    %
    % Return Value:
    %   The vector of the canonical basis in dimension dim is returned, in row form
    %
    % See also util


    v = zeros(1, dim);
    v(n) = 1;
end
