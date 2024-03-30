classdef Edge
    %EDGE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties(SetAccess=private, GetAccess=public)
        V1 double,
        V2 double
    end
    
    methods
        function obj = Edge(V1, V2)
            %EDGE Construct an instance of this class
            %   Detailed explanation goes here
            assert(all(size(V1) == size(V2)))
            obj.V1 = V1;
            obj.V2 = V2;
        end

        function h = keyHash(obj)
            % KEYHASH Compute the hash of and edge
            % 
            % @implNote
            % Vertices are converted to int, this may results in many
            % collisions if distance between points is less than one.
            % There is no easy solution to this problem.
            h = bitxor(keyHash(int64(obj.V1)), keyHash(int64(obj.V2)), 'uint64');
        end

        function eq = eq(objA, objB)
            eq = keyMatch(objA, objB);
        end

        function tf = keyMatch(objA, objB)
            tf = all(size(objA.V1) == size(objB.V1)) ...
                 && (   (matrixEquals(objA.V1, objB.V1) && matrixEquals(objA.V2, objB.V2)) ...
                     || (matrixEquals(objA.V1, objB.V2) && matrixEquals(objA.V2, objB.V1)));
        end
    end
end

