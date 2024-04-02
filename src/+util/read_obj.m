function [polyhedra] = read_obj(objFile, useHRep)
    %OBJREADER Read a .obj file and returns a vector of polyhedron.
    %   Detailed explanation goes here

    if nargin < 2
        useHRep = false;
    end
    
    fid = fopen(objFile, 'r');
    assert(fid ~= -1, "Cannot open file");

    polyhedra = [];

    if useHRep
        % parse obj with HRep in mind
        % need to create A and b and keep every vertices in a set.
        A = [];
        b = [];
        vertices = [];
        offset = 0;

        while true    
            tline = fgetl(fid);
            if ~ischar(tline), break, end % check EOF
            
            ln = sscanf(tline,'%s',1); % line type 
    
            switch ln
                case 'v' % mesh vertexs
                    vertices = [vertices; sscanf(tline(2:end),'%f')'];
                case 'f'
                    face = sscanf(tline(2:end),'%d')';
                    V1 = vertices(face(1) - offset, :);
                    V2 = vertices(face(2) - offset, :);
                    V3 = vertices(face(3) - offset, :);

                    normal = cross(V2 - V1, V3 - V1);
                    A = [A; normal];
                    b = [b; dot(normal, V1)];
                case 'o' % new object
                    if height(A) > 0
                        polyhedra = [polyhedra; Polyhedron('A', A, 'b', b)];
                        offset = offset + height(vertices);
                        A = [];
                        b = [];     
                        vertices = [];
                    end
            end
        end

        if height(A) > 0
            polyhedra = [polyhedra; Polyhedron('A', A, 'b', b)];  
        end


    else
        % parse obj with VRep in mind.
        % we don't need to have a vertex set nor checking faces.
        vertices = [];
        while true    
            tline = fgetl(fid);
            if ~ischar(tline), break, end % check EOF
            
            ln = sscanf(tline,'%s',1); % line type 
    
            switch ln
                case 'v' % mesh vertexs
                    vertices = [vertices; sscanf(tline(2:end),'%f')' ];
                case 'o' % new object
                    if height(vertices) > 0
                        polyhedra = [polyhedra; Polyhedron('V', vertices)];
                        vertices = [];
                    end
            end
        end

        if height(vertices) > 0
            polyhedra = [polyhedra; Polyhedron('V', vertices)];
        end
    end
   
    fclose(fid);
end

