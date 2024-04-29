function [P,width] = corridor(coords, edges, obstacles, n)
% corridor - The function to compute the safety corridors corresponding to the graph, depending on the distance between the edges and the obstacles  [<a href="matlab:web('https://breakmit-0.github.io/')">online docs</a>]
    % 
    %
    % Usage:
    %   [P,width] = corridor(coords, edges, obstacles,smooth_number)
    %
    % Parameters:
    %   coords should be the coordinates of the points of the graph in
    %   the D-dimensionnal workspace;
    %
    %   edges should be a l X 2 matrix which contains the edges of the
    %   graph
    %
    %   Obstacles should be an array of N Polyhedron object of dimension D
    % 
    %   smooth_number should be a scalar. It is mainly used to have smooth 
    %   corridors extremities.
    %
    % Return Values:
    %   P is an array of l polyhedra which represent the safety corridors.
    %   width is the array of the width of each corridor.
    %
    %   Warning - For now, the function only works in 2D and 3D cases ! -  
    %
    % See also main, graph
    
    %Initialization of the values of interest (described above) 
    l = height(edges);
    N = length(obstacles);
    D = obstacles(1).Dim;
    P = repmat(Polyhedron(), l-1, 1);
    width = zeros(l-1,1); 
    
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
    %and each obstacle
    d_obstacles = zeros(N,1);

    %Initialization of the matrix of the points of the polyhedron 
    %that will describe the current corridor
    points = zeros(D,n);
   
    for i=1:(l-1)
        %For each edge of the graph, the function calculates the distance
        %between this edge and each obstacle, and took the minimum for the
        %width of the corresponding corridor.
        edge = edges(i,:);
        extremities = edge.EndNodes;
        A = [coords(extremities(1),:)];
        B = [coords(extremities(2),:)];
        Q = Polyhedron('V',[A;B]);
        for j=1:N
            ret = distance(obstacles(j),Q);
            d_obstacles(j) = ret.dist;
        end
        width(i) = min(d_obstacles);
        
        %Unit vector of the edge
        normalized = (B-A)/norm(B-A);
        
        %Construction of the current corridor with the discretization of
        %the circle/sphere
        if D == 2
            ortho = normalized * rotate90;
            for k=1:n
                points(:,k) = (cos(phi(k))*ortho*width(i)+sin(phi(k))*normalized*width(i))';
            end
        elseif D == 3 
            ortho1 = normalized * rotate90;
            ortho2 = cross(normalized,ortho1);
            for k=1:num
                for m=1:num
                    points(:,k*num+m) = (cos(phi(m))*(cos(theta(k))*ortho1*width(i) + sin(theta(k))*ortho2*d)+sin(phi(m))*normalized*width(i))';
                end
            end
        end
        P(i) = Polyhedron([points + A' points + B']');
    end
end
