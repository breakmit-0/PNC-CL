function robot_radius = radius(robot)    
% radius - The function to compute the radius of the circonscrite hypersphere of the robot  [<a href="matlab:web('https://breakmit-0.github.io/util/')">online docs</a>]
    % 
    %
    % Usage:
    %    robot_radius = radius(robot)
    %
    % Parameters:
    %   robot should be a Polyhedron object
    % 
    %
    % Return Values:
    %   robot_radius is the radius of the circonscrite hypersphere of the
    %   robot
    %
    % See also corridors.edge_weight_robot
    
    bary = util.barycenter(robot);
    robot_radius = 0;
    points = robot.V;
    n = height(points);
    for i=1:n
        point = points(i,:);
        if norm(point-bary)>robot_radius
            robot_radius = norm(point-bary);
        end
    end
end