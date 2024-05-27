function lamda = centeredEnlargement(obj,Aq,bq,Ah,bh,cq)

    % min mu1
    %   x = [mu1,mu2,tildaU]
    % s.t. 
    %   tildaU * Aq = mu1 * Ah
    %   tildaU * b1 - Aq * cq <= mu2 * bh
    %   mu1 - mu2 = 1
    %   mu1 >= 1
    %   mu2 >= 0
    %   tildaUi,j >= 0
    
    
    Aeq = [];
    beq = [];
    A   = [];
    b   = [];
    lb  = [];
    ub  = [];
    

    
    dim  = size(Aq,2);
    numq = size(Aq,1);
    numh = size(Ah,1);
 
    
    if dim ~= size(Ah,2)
        error('the dimensions are not equal!')
    end
    
    
    mu1Loc      = 1;
    mu2Loc      = 2;
    tildaULoc   = 3 : 2 + numq * numh;
        
    numVar = tildaULoc(end);
    x0  = ones(numVar,1);

    Aeq1 = zeros(dim * numh, numVar);
    Atmp = [];
    Atmp1= [];
    for i = 1:numh
        list = [];
        for j = 1:dim
            list = [list;Aq(:,j)'];
            Atmp1= [Atmp1; Ah(i,j)];
        end
        Atmp = blkdiag(Atmp,list);
    end
    Aeq1(:,tildaULoc) = Atmp; %diag(reshape(Aq,[],1));
    Aeq1(:,mu1Loc) = -Atmp1;
    beq1 = zeros(dim * numh,1);
    
    
    
    Aeq2 = zeros(1,numVar);  
    Aeq2(1,mu1Loc) =  1; 
    Aeq2(1,mu2Loc) = -1; 
    beq2 = 1;
    
    A1 = zeros(numh,numVar);
    
    tmp = [];
    for i = 1:numh
        tmp = blkdiag(tmp,bq');
    end
    
    A1(1:numh,tildaULoc) = tmp;
    A1(1:numh,mu2Loc)    = -bh;
    b1                   = Ah * cq;
        
      
    
    A3 = zeros(1,numVar);
    A3(mu1Loc) = -1;
    b3 = -1;
    
    
    A4 = zeros(1,numVar);
    A4(mu2Loc) = -1;
    b4 = 0;
    
    
    A5 = zeros(numq * numh,numVar);
    A5(:,tildaULoc) = -eye(numq * numh);
    b5 = zeros(numq * numh,1);
    
    A = [A1;A3;A4;A5];
    b = [b1;b3;b4;b5];
    
    Aeq = [Aeq1;Aeq2];
    beq = [beq1;beq2];
    
    c           = zeros(numVar,1);
    c(mu1Loc,1) = 1;
    

    % options = optimoptions('linprog');
    % options.ConstraintTolerance = 1e-8;
    % options.Algorithm = 'interior-point';
    % options.MaxIterations = 10000;
    % options.Display = 'none';
    
    
    
    x = sdpvar(numVar,1);
    
    Objective = c' * x;
    Constraints = [ A*x <= b, Aeq*x == beq ];

    optSettings = sdpsettings();
    optSettings.solver = 'linprog';
    optSettings.verbose = 0;
    optSettings.cachesolvers = 1;
    sol = optimize(Constraints,Objective,optSettings);
    x = double(x);

    lamda = 1 + 1 / x(mu2Loc);   

end