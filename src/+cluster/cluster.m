function [groups, hulls] = cluster(polyhedra, k, spacemin, spacemax)
arguments
    polyhedra (:, 1) Polyhedron;
    k (1, 1) uint32;
    spacemin (1, :) double;
    spacemax (1, :) double;
end
    polyhedra = polyhedra(~[polyhedra.isEmptySet()]);

    N = size(polyhedra, 1);
    D = polyhedra(1).Dim;

    pcenters = zeros(N, D);
    for i = 1:N
        pcenters(i, :) = util.barycenter(polyhedra(i));
    end

    groups = zeros(N, 1, 'uint32');
    hulls(1:k, 1) = Polyhedron('H', zeros(0, D+1));

    % uniform distributed vectors in the bounding box
    gcenters = rand(k, D, "double") .* (spacemax - spacemin) + spacemin ;

    for i = 1:N

        if groups(i) ~= 0
            continue;
        end

        no_overlap = false;
        while ~no_overlap
            no_overlap = true;
            for j = 1:N
                if groups(j) ~=0
                    continue;
                end
                for g = 1:k
                    if ~(intersect(polyhedra(j), hulls(g)).isEmptySet())
                        no_overlap = false;
                        groups(j) = g;
                        hulls(g) = PolyUnion([hulls(g) polyhedra(j)]).convexHull();
                        break;
                    end
                end
            end
        end
        
        deltas = util.barycenter(polyhedra(i)) - gcenters;
        dst = sum(deltas .* deltas, 2);
        sorted =  sortrows([dst (1:k)'], 1);
        %
        for j = 1:k
            s = sorted(j, 2);
            
            attempt = PolyUnion([hulls(s) polyhedra(i)]).convexHull();
            intersects = false;
            
            for g = 1:k
                if (g ~= s) && ~intersect(attempt, hulls(g)).isEmptySet()
                    intersects = true;
                    break;
                end
            end

            if ~intersects
                groups(i) = s;
                hulls(s) = attempt;
                break
            end
        end

        if groups(i) == 0
            fprintf("failed to find a group for #%d\n", i);
            k = k + 1;
            groups(i) = k;
            hulls(k) = polyhedra(i);
            gcenters(k, :) = util.barycenter(hulls(k));
        end
    end


    
    for i = 1:k
        hulls(i) = PolyUnion(polyhedra(groups == i)).convexHull();
    end
end
