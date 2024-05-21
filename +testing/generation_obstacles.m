function P = generation_obstacles(dimension, Number_of_obstacles, average_size, standard_deviation_size, points_standard_deviation, space_length, max_iterations)
arguments
    dimension=3
    Number_of_obstacles=30
    average_size = 1
    standard_deviation_size = 0.1
    points_standard_deviation = 0.1
    space_length = 30
    max_iterations = 100
end

% testing.generation_obstacles The function to randomly generate obstacles in the form of convex polyhedra [<a href="matlab:web('https://breakmit-0.github.io/testing-ppl/')">online docs</a>]
    % 
    %
    % Usage:
    %   P = testing.generation_obstacles(dimension, Number_of_obstacles, average_size, standard_deviation_size, points_standard_deviation, space_length,max_iterations)
    %
    % Parameters:
    %   all inputs should be scalars
    %
    % Return Values:
    %   P is an array of Number_of_obstacles polyhedra
    %
    %   This function takes in arguments the dimension of the work space, the space
    %   length in every direction, the number of obstacles to place in this space,
    %   their average size and deviation size (where the size is the distance
    %   between the center of an obstacle and its points), the standard deviation 
    %   of the points of a sized obstacle, and a maximum number of iterations, 
    %   and randomly generates the  obstacles in the form of convex polyhedra. 
    %   
    %   These obstacles are generated so that they are disjunct. There 
    %   is a maximum number of obstacle generation iterations to avoid
    %   infinity loops if the computer is not able to generates the correct 
    %   number of disjunct obstacles with the given parameters
    %
    % See also testing
    
    if standard_deviation_size ~= 0
        R_size = chol(standard_deviation_size^2);
    else 
        R_size = 0;
    end

    if points_standard_deviation ~= 0
        R_point = chol(points_standard_deviation^2);
    else
        R_point = 0;
    end

    %Initialization of the list of obstacles
    P = repmat(Polyhedron(), Number_of_obstacles, 1);

    %Initialization of the matrix which associates a center to a polyhedron
    centers = zeros(dimension, Number_of_obstacles);
    
    %Generation of Number_of_obstacles disjunct obstacles
    i=1;
    count_iterations=1;
    while i<=Number_of_obstacles && count_iterations< Number_of_obstacles + max_iterations
        %Centers are uniformly distribued in the space considering the space length 
        centers(:,i) = (rand(dimension,1)*2.-1)*space_length/2;

        %The number of points of a polyhedron is randomly chosen and takes value
        %from dimension+1 to dimension + 11 with more polyhedra with few points
        geometric_factor = ((rand)^3)*10;
        Number_of_points = dimension + 1 + int32(geometric_factor);

        %each polyhedron has a size, which is randomly chosen with a gaussian
        %distribution of parameters : the average size value and the standard
        %deviation size
        points = zeros(dimension, Number_of_points);
        size = average_size + randn*R_size;

        %then, for each point of the polyhedron, a normalized vector is
        %uniformly chosen on the unit circle. The point is placed at the
        %distance "size * (1 + random distance chosen with a gaussian distribution
        %of parameters 0 and the standard deviation of the points)"
        vector = zeros(dimension,Number_of_points);
        for j=1:Number_of_points
            vector(:,j) = (rand(1,dimension)-0.5)*2;
            point_deviation = randn*R_point; 
            points(:,j) = vector(:,j)/norm(vector(:,j))*size*(1+point_deviation);
        end
        
        %The new polyhedron is saved in the array P if it doesn't have a 
        %non-empty intersection with a previous one
        new_polyhedron = Polyhedron(points') + centers(:,i);
        new_polyhedron = minVRep(new_polyhedron);
        count_iterations = count_iterations + 1;
        if i==1
            P(i) = new_polyhedron;
            i = i+1;
        else
            check = 1;
            for j=1:(i-1)
                if not(intersect(new_polyhedron,P(j)).isEmptySet())
                    check = 0;
                end
            end
            if check
                P(i) = new_polyhedron;
                i = i+1;
            end
        end
    end
end
