function [flag, trajectory, controllerList] = relayMPC(obj, path, PI, x0)
flag = 1;
xs = x0;

trajectory = [];
controllerList = [];

obj.settings.terminal_set_use = 1;

for segment = 1:length(PI) 
    if segment < length(PI)

        xf = pinv(obj.C) * path.V(segment+1,:)';

        H=struct('A',[PI(segment).A;PI(segment+1).A],'B',[PI(segment).b;PI(segment+1).b]);
        s = cddmex('extreme', H);
        R = Polyhedron(util.minkowskiSum(s.V,-path.V(segment+1,:)));

        if obj.settings.terminal_set_fast
            if isEmptySet(obj.tmpXf)
                Xf        = obj.controlInvariant(obj.A - obj.B * obj.K, 'C', obj.C, 'Y', R, 'U', obj.U, 'K', obj.K);
                obj.tmpXf = Polyhedron(Xf.V*0.01);
            else
                lambda = obj.centeredEnlargement(obj.tmpXf.A, obj.tmpXf.b, R.A * obj.C, R.b, zeros(obj.nx,1));
                Xf = Polyhedron(obj.tmpXf.A, obj.tmpXf.b * lambda);
                if isnan(lambda) || isinf(lambda) || isEmptySet(Xf)
                    % display('WarningL enlarged as NaN or Inf!')
                    Xf = obj.controlInvariant(obj.A - obj.B * obj.K, 'C', obj.C, 'Y', R, 'U', obj.U, 'K', obj.K);
                    obj.tmpXf = Xf;
                end
            end


        else
            Xf = obj.controlInvariant(obj.A - obj.B * obj.K, 'C', obj.C, 'Y', R, 'U', obj.U, 'K', obj.K);
        end
        
        Ntmp = obj.backwardsReachableSet(PI(segment),Polyhedron(xf'),xs);
        Y = Polyhedron(util.minkowskiSum(PI(segment).V, -(obj.C*xf)'));
        obj.setNewOutputConstraint(Y);
        
        obj.construct(Ntmp, Xf);
        obj.setController();

        controllerList = [controllerList; copy(obj)];
        u = controllerList(segment).controller(-xf + xs);

        xt = xs';
        x = xs;
        for k = 0:obj.Np-1
            uk = u(k * obj.nu + 1: (k + 1) * obj.nu);
            x = obj.A * x + obj.B * uk;
            xt = [xt; x'];
        end  
        xs = xt(end,:)';
        trajectory = [trajectory; xt];
        
    else
        xf = pinv(obj.C) * path.V(segment+1,:)';

        Ntmp = obj.backwardsReachableSet(PI(segment),Polyhedron(xf'),xs);
        Y = Polyhedron(util.minkowskiSum(PI(segment).V, -(obj.C*xf)'));
        obj.setNewOutputConstraint(Y);

        Xf = obj.nBox(0.1,obj.nx);
        obj.construct(Ntmp+5,Xf);
        obj.setController();

        controllerList = [controllerList; copy(obj)];
        u = controllerList(segment).controller(-xf + xs);

        xt = xs';
        x = xs;
        for k = 0:obj.Np-1
            uk = u(k * obj.nu + 1: (k + 1) * obj.nu);
            x = obj.A * x + obj.B * uk;
            xt = [xt; x'];
        end  
        xs = xt(end,:)';
        trajectory = [trajectory; xt];
    end


end
end