% Generate the polyhedron of the box
function out = box(dim, size)
   
    if dim == 3
        out = Polyhedron([
            0 0 -10000;
            0 size -10000;
            size 0 -10000;
            0 0 10000;
            size size -10000;
            size 0 10000;
            0 size 10000;
            size size 10000;
            ]);
    end
    if dim == 2
        out = Polyhedron([
            0 0;
            size 0;
            0 size;
            size size;
        ]);
    end

end
