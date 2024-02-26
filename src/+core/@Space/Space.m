
classdef Space
    properties (SetAccess = private)
        size (2, 1) 
    end

    methods (Static)
        function self = Space()
            arguments (Output) 
                self 
            end
            self.size = [0, 0];
        end
    end

    methods (Access = public, Static = false)
        size = get_size(self)
    end
end

