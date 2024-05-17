
classdef EmptyLifting < Lifting
    methods
        function res = isSuccess(~)
            res = false;
        end
        function res = getPartition(~, ~)
            res = [];
        end
        function res = getDiagnostics(~)
            res = struct();
        end
    end
end
