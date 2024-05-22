
classdef LiftGraph
    properties
        g (1, 1) graph;
        neighbour_info (1, 1) logical = false;
        width_info (1, 1) logical = false;
    end

    methods 

        function self = LiftGraph(g)
            self.g = g;
        end
        function self = calculateWidths(self)
            if self.width_info
                return;
            end
        end
    end
end
