function write_obj(polyhedra, path)
    fid = fopen(path, 'w');
    assert(fid ~= -1, "Cannot open file");

    polyIndex = 0;
    absolutionVertexIndex = 0;
    for p = polyhedra.'
        polyIndex = polyIndex + 1;
        dim = p.Dim;

        if dim >= 4
            warn("Cannot export " + polyIndex + "-th polyhedron to obj because 4 dimension or more");
            continue
        end


        fprintf(fid, "o Polyhedron.%i\n", polyIndex);
        p.minHRep();
        vertices = p.V;
        
        % write vertices
        for v = vertices.'
            x = v(1);
            if dim == 1
                y = 0;
            else
                y = v(2);
            end
            if dim <= 2
                z = 0;
            else
                z = v(3);
            end
            
            fprintf(fid, "v %f %f %f\n", x, y, z);
        end

        % write facets
        if height(vertices) == 1
            continue % one point => no facets
        elseif height(vertices) == 2
            % two points => line
            fprintf(fid, "l %i %i\n", vertices(1), vertices(2));
        else
            % three or more => facet
            
            if dim == 2 || height(p.Ae) > 0
                % the polyhedron is a facet
                facets = p;
            else
                % multiple facets
                facets = p.getFacet();
            end

            for facet = facets.'
                fV = facet.V;
                fprintf(fid, "f");
                for vertex = fV.'
                    vertexIndex = absolutionVertexIndex + util.index_of(vertices, vertex.');
                    fprintf(fid, " %i", vertexIndex);
                end
                fprintf(fid, "\n");
            end
        end

        absolutionVertexIndex = absolutionVertexIndex + height(vertices);
    end

    fclose(fid);
end

