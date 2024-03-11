

function poly = rand_poly(offset)
    x = rand(5, size(offset, 2)) + offset;
    poly = Polyhedron(x); 
end
