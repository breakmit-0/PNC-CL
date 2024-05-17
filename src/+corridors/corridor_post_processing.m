function [P, min_width, path_length] = corridor_post_processing(G, path, n)
% corridor - The function to describes the safety corridors of the path with Polyhedra  [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    [P, min_width, path_length] = corridor(G, path, smooth_number)
    %
    % Parameters:
    %   G should be the graph returned by edge_weight
    %
    %   path should be the array of l points returned by alt_graph.path 
    %
    %   smooth_number should be a scalar. It is mainly used to have smooth
    %   corridors extremities.
    %
    % Return Values:
    %   P is an array of l-1 polyhedra of dimension D which represent the 
    %   safety corridors.
    %
    %   min_width is the width of the narrowest corridor in the path
    %
    %   path_length is the length of the path
    %
    %
    % Warning - For now, the function only works in 2D and 3D cases ! 
    %
    % See also corridors, edge_weight, alt_graph.path
    
    %Coordinates of the nodes of the graph, corridor width and length
    %for each edge of the graph
    coords = G.Nodes.position;
    corridors_width = G.Edges.width;
    edge_length = G.Edges.length;
    extremities = G.Edges.EndNodes;
    L = height(extremities);

    %Initialization of the values of interest (described above)
    l = length(path);
    D = width(G.Nodes.position);
    P = repmat(Polyhedron(), l-1, 1);
    min_width = +inf;
    path_length = 0;

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

    %Initialization of the matrix of the points of the polyhedron 
    %that will describe the current corridor
    points = zeros(D,n);

    for i=1:(l-1)
        %Finding the edge corresponding to (path(i) path(i+1)) in the
        %graph to have the correct index for corridors_width
        index = findedge(G, path(i), path(i+1));

        %min_width and path_length updated with the new corridor/edge
        min_width = min(min_width, corridors_width(index));
        path_length = path_length + edge_length(index);
        
        %Unit vector of the edge
        A = [coords(path(i),:)];
        B = [coords(path(i+1),:)];
        normalized = (B-A)/norm(B-A);

        %Construction of the current corridor with the discretization of
        %the circle/sphere
        if D == 2
            ortho = normalized * rotate90;
            for k=1:n
                points(:,k) = (cos(phi(k))*ortho*corridors_width(index)+sin(phi(k))*normalized*corridors_width(index))';
            end
        elseif D == 3 
            ortho1 = normalized * rotate90;
            ortho2 = cross(normalized,ortho1);
            for k=1:num
                for m=1:num
                    points(:,k*num+m) = (cos(phi(m))*(cos(theta(k))*ortho1*corridors_width(index) + sin(theta(k))*ortho2*corridors_width(index))+sin(phi(m))*normalized*corridors_width(index))';
                end
            end
        end
        P(i) = Polyhedron([points + A' points + B']');
    end
end
