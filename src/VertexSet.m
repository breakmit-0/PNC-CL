classdef VertexSet < handle

    properties (SetAccess = private)
        vertices
    end
    
    methods
        function obj = VertexSet()
            obj.vertices = [];
        end
        
        function index = getIndex(obj, vertex)
            index = -1;
            for i = 1:height(obj.vertices)
                if obj.vertices(i, :) == vertex
                    index = i;
                    break
                end
            end
            
            if index < 0
                obj.vertices = [obj.vertices; vertex];
                index = height(obj.vertices);
            end
        end
    end
end

