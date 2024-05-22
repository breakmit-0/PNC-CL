function out = box(center, radius, sh)
    % util.box Generates a hypercube Polyhedron
    %
    % Usage:
    %   p = box(center, radius)             generates a hypercube around center
    %   p = box(center, radius, height)     uses a different value for the last dimension of the hypercube
    %
    % Parameters:
    %   center is a row vector, the dimension of the output Polyhedron is the size of center 
    %   radius is a scalar, the cubes edges have length 2*radius
    %   height (optional) has the same effect as radius for the last dimension
    %
    % Return Value:
    %   A Polyhedron object in H representation with 2*length(center) faces is returned
    %
    % See also util

    arguments
        center;
        radius;
        sh = radius;
    end

    D = size(center);
    D = D(2);

    A = zeros(2*D, D);
    b = zeros(2*D, 1);

    for i = 1:D 
        u = util.unit_vec(D,i);
        A(2*i-1,:) = u;
        b(2*i-1) = radius + center(i);
        A(2*i,:) = -u;
        b(2*i) = radius - center(i);
    end

    b(2*D-1) = sh;
    b(2*D) = sh;

    out = Polyhedron('A', A, 'b', b);
end
