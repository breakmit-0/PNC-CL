classdef mpcsettings < handle
%
% A setting class for mpc object. Includes necessary variables required to
% be defined to generate an mpc object.
%
%
% See documentation: https://github.com/breakmit-0/PNC-CL
%
%

    
    properties (Access = public)   
        % parameters
        A = [];
        B = [];
        C = [];
        D = [];
        dt= 1;
        
        Q = [];
        R = [];

        sys = [];
        
        Np = 0;
        
        terminal_cost_use = 0;
        terminal_set_use  = 0;
        terminal_set_fast = 0;
        
        backwards_reachability_scaler = 1;
        
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

        function obj = default2D(obj)
            obj.dt = 0.4;
            obj.A = [0  0  1  0;
                     0  0  0  1;
                     0  0  0  0;
                     0  0  0  0];
            obj.B = [0 0;0 0;1 0;0 1];
            obj.C = [1 0 0 0;
                     0 1 0 0]; 
            obj.D = 0;

            obj.sys = ss(obj.A, obj.B, obj.C, obj.D);
            
            obj.Q = diag([2,2,10,10]);
            obj.R = eye(2);

            obj.terminal_cost_use = 1;
            obj.terminal_set_use = 1;
            obj.terminal_set_fast = 1;
            obj.backwards_reachability_scaler = 4;
            
            obj.u.min = [-2,-2];
            obj.u.max = [ 2, 2];
            obj.x.set = Polyhedron;
            obj.Np = 12;
        end


        function obj = default3D(obj)
            obj.dt = 1;
            obj.A = [0  0  0  1  0  0;
                     0  0  0  0  1  0;
                     0  0  0  0  0  1;
                     0  0  0  0  0  0;
                     0  0  0  0  0  0;
                     0  0  0  0  0  0];
            obj.B = [0 0 0;0 0 0;0 0 0;1 0 0;0 1 0;0 0 1];
            obj.C = [1 0 0 0 0 0;
                     0 1 0 0 0 0;
                     0 0 1 0 0 0]; 
            obj. D = 0;

            obj.sys = ss(obj.A, obj.B, obj.C, obj.D);
            
            obj.Q = diag([2,2,2,10,10, 10]);
            obj.R = eye(3)*10;

            obj.terminal_cost_use = 1;
            obj.terminal_set_use = 1;
            obj.terminal_set_fast = 1;
            obj.backwards_reachability_scaler = 5;

            obj.x.set = Polyhedron;
            obj.u.min = [-2,-2,-2];
            obj.u.max = [ 2, 2, 2];
            obj.Np = 12;
        end

    end
end