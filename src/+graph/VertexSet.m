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
        function index = get_index(obj, vertex)
            index = -1;
            for i = 1:height(obj.vertices)
                if util.matrix_equals(obj.vertices(i, :), vertex, 1e-3)
                    index = i;
                    break
                end
            end
            
            if index < 0
                obj.vertices = [obj.vertices; vertex];
                index = height(obj.vertices);
            end
        end


        function [index, new] = get_indexn(obj, vertex)
            index = -1;
            for i = 1:height(obj.vertices)
                if util.matrix_equals(obj.vertices(i, :), vertex, 1e-3)
                    index = i;
                    break
                end
            end
            
            if index < 0
                new = true;
                obj.vertices = [obj.vertices; vertex];
                index = height(obj.vertices);
            else
                new = false;
            end
        end


        function clear(obj)
            obj.vertices = [];
        end

        function s = size(obj)
            s = height(obj.vertices);
        end

        function coords = extract_coords(obj, dimension)
            coords = obj.vertices(:, dimension);
        end
    end
end

