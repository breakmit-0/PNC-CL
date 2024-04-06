function [polyhedra] = read_obj(objFile)
    % util.read_obj Read a .obj file and returns a column vector of polyhedra.
    % 
    % Parameters:
    %     objFile: the file to read
    %
    % Return value:
    %     polyhedra: the loaded polyhedra.

    fid = fopen(objFile, 'r');
    assert(fid ~= -1, "Cannot open file");

    polyhedra = [];

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
   
    fclose(fid);
end

