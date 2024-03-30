% A utility class to map vertex (column vector) to integer. It stores a 
% list of vertices, thus the index of vertex is the index in the list.
classdef VertexSet < handle

    properties
        vertices
    end
    
    methods
        
        % Create an empty VertexSet
        function obj = VertexSet()
            obj.vertices = [];
        end
        
        % Return the index of vertex. If the vertex isn't in the set, it is
        % added.
        % param:
        % * vertex: a column vector, it should have the same size as the
        % previously added vectors.
        % return: the index of vertex
        function index = getIndex(obj, vertex)
            index = -1;
            for i = 1:height(obj.vertices)
                if matrixEquals(obj.vertices(i, :), vertex, 1e-5)
                    index = i;
                    break
                end
            end
            
            if index < 0
                obj.vertices = [obj.vertices; vertex];
                index = height(obj.vertices);
            end
        end


        function coords = extractCoords(obj, dimension)
            coords = obj.vertices(:, dimension);
        end
    end
end

