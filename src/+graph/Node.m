classdef Node < handle
    %LINKEDLIST Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        value
    end

    properties (SetAccess = private)
        prev = graph.Node.empty
        next = graph.Node.empty
    end
    
    methods        
        function node = insert_after(obj, value)
            node = graph.Node();
            node.prev = obj;
            
            if ~isempty(obj.next)
                node.next = obj.next;
                node.next.prev = node;
            end

            node.value = value;
            obj.next = node;
        end

        function node = remove(obj)
            if isempty(obj.prev) && isempty(obj.next)
                error("Cannot remove node from a 1-sized linked list")
            end

            node = obj.next;

            next = obj.next;
            prev = obj.prev;

            if ~isempty(prev)
                prev.next = next;
            end
            if ~isempty(next)
                next.prev = prev;
            end

            obj.prev = graph.Node.empty;
            obj.next = graph.Node.empty;
        end
    end

    methods (Static)
        function head = row_vector_to_linked_list(vector)
            if height(vector) ~= 1
                error("Not a row vector")
            end

            head = graph.Node();
            head.value = vector(1);
            node = head;
            for i = 2:width(vector)
                node = node.insert_after(vector(i));
            end
        end
    end
end

