function [faces] = projectFacets(oa, ob, space)
    [N, D] = size(oa);
    A = cat(2, oa, -ones(N, 1));
    P = Polyhedron(A, ob); %.intersect(box(D+1, 100));
    P.minHRep();
    bbx = box(D, space);
    faces = P.getFacet();
   
    figure;
    plot(faces.intersect(box(D+1, space))); 
    
    figure; 
    plot(faces);
    faces = arrayfun(@(x) projection(x, 1:(P.Dim - 1)), faces);
    % plot(faces);
    figure;
    faces = arrayfun(@(x) x.intersect(bbx), faces);
end
