
classdef EmptyLifting < Lifting
    % Placeholder class for a not yet set lifting
    %
    % See Also Lifting, lift
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
