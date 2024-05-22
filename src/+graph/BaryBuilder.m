classdef BaryBuilder < GraphBuilder

    methods
        function G = buildGraph(self, partition)
            if (partition.Dim ~= 3)
                error("WithCenters graph builder only works in dimension 3")
            end


        end
    end
end
