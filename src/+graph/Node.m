classdef Node < handle
    %NODE Simple linked list
    %   Used by graph.GraphBuilder.validate.
    
    properties
        % value hold by this Node
        value
    end

    properties (SetAccess = private)
        % previous node
        prev = graph.Node.empty
        % next node
        next = graph.Node.empty
    end
    
    methods
        function obj = Node(value)
            obj.value = value;
        end

        function node = insertAfter(obj, value)
            % INSERTAFTER Insert a node with value 'value' just after this
            % node.
            % 
            % Paramaters:
            %     value: the value to add after
            % 
            % Return value:
            %     node: the node inserted after.

            node = graph.Node(value);
            node.prev = obj;
            
            if ~isempty(obj.next)
                node.next = obj.next;
                node.next.prev = node;
            end

            obj.next = node;
        end

        function node = remove(obj)
            % REMOVE Remove this node from the linked list
            % 
            % If the linked list only contains this node, the function
            % fail. Zero-length linked list aren't supported.
            %
            % Return value:
            %     node: the node after this node

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
        function head = rowVectorToLinkedList(vector)
            % ROWVECTORTOLINKEDLIST convert a row vector to a linked
            % list
            %
            % Parameter:
            %     vector: a row vector
            % 
            % Return values:
            %     head: the head of the linked list created

            if height(vector) ~= 1
                error("Not a row vector")
            end

            head = graph.Node(vector(1));
            node = head;
            for i = 2:width(vector)
                node = node.insertAfter(vector(i));
            end
        end
    end
end

