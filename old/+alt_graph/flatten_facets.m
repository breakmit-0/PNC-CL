function facets = flatten_facets(poly_list)
    % fprintf("\tentering function\n")

    N = size(poly_list, 1);
    alloc_size = 0;
    
    % fprintf("\tcalculating alloc size\n");

    for i = 1:N

        % fprintf("#%d\n", i);
        % disp(poly_list(i));

        % assert(~poly_list(i).isEmptySet());
        % assert(~poly_list(i).isFullSpace());

        [~, s] = poly_list(i).minHRep();
        if (~poly_list(i).irredundantHRep)
            fprintf("failed @ i = %d with minHrep\n", i);
            disp(s);
            assert(0);
        end

        alloc_size = alloc_size + size(poly_list(i).H, 1);
    end


    % fprintf("\tcalculating output\n");

    facets(1:alloc_size, 1) = Polyhedron();
    store = 1;
    for i = 1:N
        F = size(poly_list(i).H, 1);
        facets(store:store+F-1) = poly_list(i).getFacet(1:F);
        store = store + F;
    end

    % fprintf("\tdone\n");
end
