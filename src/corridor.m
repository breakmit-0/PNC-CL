function [P,d] = corridor(Coords,path,obstacles,n)
    
    l = length(path);
    N = length(obstacles);
    D = obstacles(1).Dim;
    P = repmat(Polyhedron(), l-1, 1);
    if D == 2
        rotate90 = [0 -1; 1 0];
        phi = linspace(0, 2*pi, n);
    elseif D==3
        rotate90 = [0 -1 0; 1 0 0; 0 0 1];
        num = floor(sqrt(n));
        phi = linspace(0, 2*pi, num);
        theta = linspace(0, 2*pi, num);
    else
        error("Corridors make sense only in 2D and in 3D")
    end

    for i=1:(l-1)
        A = [Coords(path(i),:)];
        B = [Coords(path(i+1),:)];
        Q = Polyhedron('V',[A;B]);
        d_obstacles = zeros(N,1);
        for j=1:N
            ret = distance(obstacles(j),Q);
            d_obstacles(j) = ret.dist;
        end
        d = min(d_obstacles);
        normalized = (B-A)/norm(B-A);
        
        points = [];

        if D == 2
            ortho = (rotate90 * normalized' * d)';
            for k=1:n
                points = [points (cos(phi(k))*ortho+sin(phi(k))*normalized*d)'];
            end
        elseif D == 3 
            ortho1 = (rotate90 * normalized' * d)';
            ortho2 = cross(normalized,ortho1);
            for k=1:num
                for m=1:num
                    points = [points (cos(phi(m))*(cos(theta(k))*ortho1 + sin(theta(k))*ortho2)+sin(phi(m))*normalized*d)'];
                end
            end
        end
     
        R = Polyhedron([points + A' points + B']');
        P(i) = R.minHRep();
    end
end