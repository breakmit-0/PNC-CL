function out = Generation_obstacles(dimension, Number_of_obstacles, average_size, standard_deviation_size, points_standard_deviation, space_length)
arguments
    dimension=3
    Number_of_obstacles=30
    average_size = 3
    standard_deviation_size = 0.2
    points_standard_deviation = 0.01
    space_length = 30
end

%This function takes in arguments the dimension of the work space, the space
%length in every direction, the number of obstacles to place in this space,
%their average size and deviation size (where the size is the distance
%between the center of an obstacle and its points), and the standard 
%deviation of the points of a sized obstacle, and randomly generates the 
%obstacles in the form of convex polyhedra

R_size = chol(standard_deviation_size^2);
R_point = chol(points_standard_deviation^2);

%Initialization of the list of obstacles
P = repmat(Polyhedron(), 1, Number_of_obstacles);

%Initialization of the matrix which associates a center to a polyhedron
centers = zeros(dimension, Number_of_obstacles);

for i=1:Number_of_obstacles
    %Centers are uniformly distribued in the space considering the space length 
    centers(:,i) = rand(dimension,1)*space_length;
    
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

    %The new polyhedron is saved in the list
    P(i) = Polyhedron(points') + centers(:,i);
    end
end
plot(P)
out = P;
