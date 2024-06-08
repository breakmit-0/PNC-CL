classdef mpc < matlab.mixin.Copyable
%
% Refer to example for documentation on the usage of this class 
%
%

    
    properties (Access = public)   

        %% parameters
        A = [];
        B = [];
        C = [];
        D = [];
        
        Q = [];
        R = [];
        
        Np = 0;
        Nc = 0;
        
        controller = 0;
        
    end

    properties (Access = public)
        nx = 0;nu = 0;ny = 0;
        
        Pi = [];Gamma = [];PSI = [];PHI = [];
        
        K = [];
        Qp= [];
        
        HX = [];  HY = [];   HU = [];
        Hx = [];  Hy = [];   Hu = [];
        
        wx = [];  wy = [];   wu = [];
        WX = [];  WY = [];   WU = [];
        
        H = [];
        F = [];

        U = [];
        X = [];
        Y = [];
        Xf = Polyhedron;

        box_width = 0.001;
        box = Polyhedron;
        XfTilde = Polyhedron;
        
        settings = mpcsettings();
        
    end
    
    methods
    function obj = mpc(option)
        obj.A = option.A;
        obj.B = option.B;
        obj.C = option.C;
        obj.D = option.D;
        
        obj.Q = option.Q;
        obj.R = option.R;
        
        obj.settings = option;        
        
        if size(obj.A,1) == size(obj.A,2) 
            obj.nx = size(obj.A,1);
        else
            error("State matrix should be square!") 
        end
        
        
        if size(obj.A,1) == size(obj.B,1) 
            obj.nu = size(obj.B,2);
        else
            error("Size A in 1 not equal to size B in 2!") 
        end
        
        
        if size(obj.A,1) == size(obj.C,2) 
            obj.ny = size(obj.C,1);
        else
            error("Size A in 1 not equal to size C in 2!") 
        end
        
        [obj.K, obj.Qp] = dlqr(obj.A, obj.B, obj.Q, obj.R);
        
        if isempty(option.x.set)
            [obj.Hx, obj.wx] = obj.generateSet(option.x.min, option.x.max, obj.nx);
            obj.X = Polyhedron(obj.Hx, obj.wx);
        elseif isa(option.x.set, 'Polyhedron')
            if isEmptySet(option.x.set)
                obj.Hx = zeros(1,obj.nx);
                obj.wx = 0;
            else
                obj.Hx = option.x.set.A;
                obj.wx = option.x.set.b;
            end
            obj.X = Polyhedron(obj.Hx, obj.wx);
        end
        
        if isempty(option.u.set)
            [obj.Hu, obj.wu] = obj.generateSet(option.u.min, option.u.max, obj.nu);
            obj.U = Polyhedron(obj.Hu, obj.wu);
        elseif isa(option.u.set, 'Polyhedron')
            obj.Hu = option.u.set.A;
            obj.wu = option.u.set.b;
            obj.U = Polyhedron(obj.Hu, obj.wu);
        end


        % if isempty(option.x.set)
        %     [obj.Hx, obj.wx] = obj.generateSet(option.x.min, option.x.max, obj.nx);
        %     obj.X = Polyhedron(obj.Hx, obj.wx);
        % elseif isa(option.x.set, 'Polyhedron')
        %     if isEmptySet(option.x.set)
        %         obj.Hx = zeros(1,obj.nx);
        %         obj.wx = 0;
        %     else
        %         obj.Hx = option.x.set.A;
        %         obj.wx = option.x.set.b;
        %     end
        %     obj.X = Polyhedron(obj.Hx, obj.wx);
        % end

        obj.box = obj.nBox(obj.box_width,obj.nx);
        obj.XfTilde = obj.controlInvariant(obj.A - obj.B * obj.K, 'X', obj.box, 'U', obj.U, 'K', obj.K);
        
        obj.Np = option.Np;
        obj.construct();
        obj.setController();
        
    end
    
    
    function obj = construct(obj, Np, Xf)
        if nargin > 1
            n = Np;
            obj.Np = n;
        else
            n = obj.Np;
        end

        % obj.Pi = zeros(obj.ny * n, obj.nx);
        obj.Pi = zeros(obj.nx * n, obj.nx);
        % obj.Gamma = zeros(obj.ny * n, obj.nu * obj.Np);
        obj.Gamma = zeros(obj.nx * n, obj.nu * n);
        obj.Xf = [];
        if obj.settings.terminal_set_use && nargin < 3
            obj.Xf = obj.controlInvariant(obj.A - obj.B * obj.K, 'X', obj.X, 'U', obj.U, 'K', obj.K);
        elseif nargin == 3
            obj.Xf = Xf;
        end
        
        obj.PSI = [];
        obj.HX  = [];
        obj.PHI = [];
        obj.HY  = [];
        obj.HU  = [];
        obj.WX  = [];
        obj.WY  = [];
        obj.WU  = [];
        for k = 0:n-1
            obj.Pi((k)*obj.nx+1:(k+1)*obj.nx,:) = obj.A^(k+1);
            % obj.Pi((k)*obj.ny+1:(k+1)*obj.ny,:) = obj.C * obj.A^(k+1);

            for i = 1:k+1
                % obj.Gamma((k)*obj.ny+1:(k+1)*obj.ny,(i-1)*obj.nu+1:(i)*obj.nu) = obj.C * obj.A^(k+1-i)*obj.B;
                obj.Gamma((k)*obj.nx+1:(k+1)*obj.nx,(i-1)*obj.nu+1:(i)*obj.nu) = obj.A^(k+1-i)*obj.B;
            end

            
            if k == n-1 && obj.settings.terminal_cost_use
                obj.PSI = blkdiag(obj.PSI, obj.Qp);
            else
                obj.PSI = blkdiag(obj.PSI, obj.Q);
            end

            if k == n-1 && obj.settings.terminal_set_use
                obj.HX = blkdiag(obj.HX, obj.Xf.A);
                obj.WX = [obj.WX; obj.Xf.b];
            else
                obj.HX = blkdiag(obj.HX, obj.Hx);
                obj.WX = [obj.WX; obj.wx];
            end
            
            obj.PHI = blkdiag(obj.PHI, obj.R);
            obj.HY = blkdiag(obj.HY, obj.Hy);
            obj.HU = blkdiag(obj.HU, obj.Hu);
            
            
            obj.WY = [obj.WY; obj.wy];
            obj.WU = [obj.WU; obj.wu];

        end
        obj.H = obj.PHI + obj.Gamma' * obj.PSI * obj.Gamma;
        obj.F = obj.Pi' * obj.PSI * obj.Gamma;


    end
    
    
    function [H,w] = generateSet(obj, min, max, dim)
        if length(min) ~= dim
            error('Length of min constraints should be equal to number of dim')
        end
        
        if length(max) ~= dim
            error('Length of constraints should be equal to number of dim')
        end
        
        H = zeros(2*dim,dim);
        w = ones(2*dim,1);
        for i = 1:dim
            H(2*i-1,i) = 1/min(i);
            H(2*i,i) = 1/max(i);
        end
    end
    
    
    function obj = setController(obj)
        optSettings = sdpsettings();
        optSettings.warmstart = 0;
        optSettings.solver = 'quadprog';
        optSettings.verbose = 3;
        optSettings.debug = 1;
        optSettings.cachesolvers = 1;
        optSettings.usex0 = 0;
        optSettings.quadprog.Algorithm = 'interior-point-convex';
        
        u = sdpvar(obj.nu*obj.Np,1);
        x = sdpvar(obj.nx,1);
        
        Constraints = obj.HU * u <= ones(size(obj.HU,1),1);
        Constraints = [Constraints, obj.HX * (obj.Pi * x + obj.Gamma * u) <= obj.WX];
        
        Objective = u' * obj.H * u + 2 * x' * obj.F * u;
        
        obj.controller = optimizer(Constraints, Objective, [], x, u);

    end


    function obj = generateSetConstraint(P,n)
        P = setBasisOnes(P);
        Hs = P.A;
        ws = P.b;
        
        for i = 1:n
            obj.HX = blkdiag(obj.HX, Hs);
        end
    end
    
    
    function obj = terminalSet(obj, Xf)
        obj.Xf = Xf;
    end


    function obj = setNewOutputConstraint(obj,P)
%         P = setBasisOnes(P);
        
        obj.Hx = [P.A * obj.C];
        obj.wx = [P.b];
    end


    function obj = setNewStateConstraint(obj, P,n)
        P = setBasisOnes(P);
        Hs = P.A;
        ws = P.b;
        
        for i = 1:n
            obj.HX = blkdiag(obj.HX, Hs);
        end
    end


    function obj = setNewInputConstraint(obj,P,n)
        P = setBasisOnes(P);
        Hs = P.A;
        ws = P.b;
        
        for i = 1:n
            obj.HX = blkdiag(obj.HX, Hs);
        end
    end


    function S = nBox(obj, r,n)
        %
        %
        % r: distance from center to the each edge
        % n: dimension
        
        
        H = zeros(2*n,n);
        w = zeros(2*n,1);
        for i = 1:n
            H((i-1)*2 + 1, i) = 1;
            w((i-1)*2 + 1) = r/2;
            H((i-1)*2 + 2, i) = -1;
            w((i-1)*2 + 2) = r/2;
        end
        
        S = Polyhedron(H,w);
    end


    end
    
end
