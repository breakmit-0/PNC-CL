function assert_shape(x, shape)
    % util.assert_shape  Makes sure that the arguement of the function has the given shape
    %
    % Usage:
    %   assert_shape(array, shape);
    %
    % Parameters:
    %   x is anything
    %   shape is a row vector of scalars
    %%
    %   This function does nothing if shape is equal to size(x) and stops the program with an error if it is not
    %
    % See also util

    assert(isequal(size(x),shape));
end

