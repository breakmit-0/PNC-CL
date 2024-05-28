classdef mpcsettings < handle


    
    properties (Access = public)   
        % parameters
        A = [];
        B = [];
        C = [];
        D = [];
        
        Q = [];
        R = [];
        
        Np = 0;
        
        terminal_cost_use = 0;
        terminal_set_use  = 0;
        terminal_set_fast = 0;
        
        regulation = 1;
        tracking = 0; % not implemented yet
        
        u = struct('min',-1, ...
                   'max', 1, ...
                   'set', []);
               
        y = struct('min',-1, ...
                   'max', 1, ...
                   'set', []);
               
        x = struct('min',-1, ...
                   'max', 1, ...
                   'set', []);
    end
    

    methods
        function obj = mpcsettings()
            return
        end

        function obj = default(obj)
            dt = 0.2;
            obj.A = [1  0 dt  0;
                 0  1  0 dt;
                 0  0  1  0;
                 0  0  0  1];
            obj.B = [0 0;0 0;1 0;0 1]*dt;
            obj.C = [1 0 0 0;
                 0 1 0 0]; 
            obj.D = 0;
            
            obj.Q = diag([2,2,10,10]);
            obj.R = eye(2)*0.1;

            obj.terminal_cost_use = 1;
            obj.terminal_set_use = 1;
            obj.terminal_set_fast = 1;
            
            obj.u.min = [-2,-2]*2;
            obj.u.max =  [2,2]*2;
            obj.Np = 12;
        end


    end
end