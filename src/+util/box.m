% Generate a cube around center
function out = box(center, radius, sh)
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
