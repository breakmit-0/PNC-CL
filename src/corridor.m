function [P,width] = corridor(vertexset,path,obstacles,n)
% corridor - The function to compute the safety corridors corresponding to the chosen path, depending on the distance between the path and the obstacles  [<a href="matlab:web('https://breakmit-0.github.io/')">online docs</a>]
    % 
    %
    % Usage:
    %   [P,width] = corridor(VertexSet,path,obstacles,smooth_number)
    %
    % Parameters:
    %   vertexset should be a VertexSet object which contains the coordinates
    %   of the points of the graph in the D-dimensionnal workspace. [G, VertexSet] 
    %   are the returned values by graphBuilder.buildGraph. 
    %
    %   path should be the array which describes the l points of the chosen path. 
    %   [path, dist] are the returned values by shortestpath.
    %
    %   Obstacles should be an array of N Polyhedron object of dimension D
    % 
    %   smooth_number should be a scalar. It is mainly used to have smooth 
    %   corridors extremities.
    %
    % Return Values:
    %   P is an array of l polyhedra which represent the safety corridors
    %   width is the width of the path : it's the width of the narrowest
    %   corridor of the path.
    %
    %   Warning - For now, the function only works in 2D and 3D cases ! -  
    %
    % See also main, graph
    
    %Initialization of the values of interest (described above) 
    l = length(path);
    N = length(obstacles);
    D = obstacles(1).Dim;
    P = repmat(Polyhedron(), l-1, 1);
    width = +inf; 
    
    %Uniform discretisation of the angles of a circle in 2D/ a sphere in 3D
    %rotate90 is a rotation matrix of angle 90°
    if D == 2
        rotate90 = [0 -1; 1 0];
        phi = linspace(0, 2*pi, n);
    elseif D==3
        rotate90 = [0 -1 0; 1 0 0; 0 0 1];
        num = floor(sqrt(n));
        n = num*num;
        phi = linspace(0, 2*pi, num);
        theta = linspace(0, 2*pi, num);
    else
        error("Corridors make sense only in 2D and in 3D")
    end
    
    %Initialization of the array of distances between the current edge of 
    %the path and each obstacle
    d_obstacles = zeros(N,1);

    %Initialization of the matrix of the points of the polyhedron 
    %that will describe the current corridor
    points = zeros(D,n);

    %Coordinates of the vertexset extraction
    Coords = vertexset.extractCoords(':');
   
    for i=1:(l-1)
        %For each edge of the path, the function calculates the distance
        %between this edge and each obstacle, and took the minimum for the
        %width of the corresponding corridor. Then global width of all
        %corridors is updated given that new data
        A = [Coords(path(i),:)];
        B = [Coords(path(i+1),:)];
        Q = Polyhedron('V',[A;B]);
        for j=1:N
            ret = distance(obstacles(j),Q);
            d_obstacles(j) = ret.dist;
        end
        d = min(d_obstacles);
        width = min(width, d);
        
        %Unit vector of the edge
        normalized = (B-A)/norm(B-A);
        
        %Construction of the current corridor with the discretization of
        %the circle/sphere
        if D == 2
            ortho = normalized * rotate90;
            for k=1:n
                points(:,k) = (cos(phi(k))*ortho*d+sin(phi(k))*normalized*d)';
            end
        elseif D == 3 
            ortho1 = normalized * rotate90;
            ortho2 = cross(normalized,ortho1);
            for k=1:num
                for m=1:num
                    points(:,k*num+m) = (cos(phi(m))*(cos(theta(k))*ortho1*d + sin(theta(k))*ortho2*d)+sin(phi(m))*normalized*d)';
                end
            end
        end
        
        R = Polyhedron([points + A' points + B']');
        P(i) = R.minHRep();
    end
end
