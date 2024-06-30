function corridor_polyhedron = draw_corridor(D, A, B, corridor_width, n)
% draw_corridor - The function to describes a safety corridor by a polyhedron  [<a href="matlab:web('https://breakmit-0.github.io/corridors/')">online docs</a>]
    % 
    %
    % Usage:
    %    corridor_polyhedron = draw_corridor(D, A, B, corridor_width, smooth_number)
    %
    % Parameters:
    %   D is the dimension
    %
    %   A and B should be two points in dimension D 
    %
    %   corridor_width should be a scalar
    %
    %   smooth_number should be a scalar. It is mainly used to have smooth
    %   corridors extremities.
    %
    % Return Values:
    %   corridor_polyhedron is a Polyhedron of dimension D which represent the 
    %   safety corridor.
    %
    %
    % Warning - For now, the function only works in 2D and 3D cases ! 
    %
    % See also corridors, corridor_post_processing
    
    points = zeros(D,n);
    normalized = (B-A)/norm(B-A);

    %Uniform discretisation of the angles of a circle in 2D/ a sphere in 3D
    %rotate90 is a rotation matrix of angle 90°
    %Construction of the current corridor with the discretization of
    %the circle/sphere
    if D == 2
        rotate90 = [0 -1; 1 0];
        phi = linspace(0, 2*pi, n);
        ortho = normalized * rotate90;
        for k=1:n
            points(:,k) = (cos(phi(k))*ortho*corridor_width+sin(phi(k))*normalized*corridor_width)';
        end
    elseif D==3
        num = floor(sqrt(n));
        phi = linspace(0, 2*pi, num);
        theta = linspace(0, 2*pi, num);
        xvector = [1 0 0];
        yvector = [0 1 0];
        if abs(dot(xvector,normalized))<abs(dot(xvector,normalized))
            ortho = xvector - dot(xvector,normalized)*normalized;
        else
            ortho = yvector - dot(yvector,normalized)*normalized;
        end
        ortho1 = ortho/norm(ortho);
        ortho2 = cross(normalized,ortho1);
        for k=1:num
            for m=1:num
                points(:,k*num+m) = (cos(phi(m))*(cos(theta(k))*ortho1*corridor_width + sin(theta(k))*ortho2*corridor_width)+sin(phi(m))*normalized*corridor_width)';
            end
        end
    else
        error("Corridors make sense only in 2D and in 3D")
    end
    corridor_polyhedron = Polyhedron([points + A' points + B']');
end
