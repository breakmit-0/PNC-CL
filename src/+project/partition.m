function P = partition(epigraph)
    % project.partition Transforms the epigraph of the convex lifting function into the polyhedral partition of the space[<a href="matlab:web('https://breakmit-0.github.io/project-ppl/')">online docs</a>]
    %
    % Usage:
    %   P = project.partition(epigraph)
    %
    % Parameters:
    %   epigraph is the value returned by project.epigraph
    %
    % Return Values:
    %   P is an array of Polyhedra
    %
    %   P is a polyhedral partition of the initial space containing the 
    %   obstacles and used to defined the graph of paths
    %   P is obtained by projecting the faces of interest of the epigraph
    %   on the initial space
    %   
    % See also project, project.epigraph, project.filter_vh

%The function gets the faces of the epigraph and only keeps the interesting
%ones thanks to the filter function
faces = epigraph.getFacet;
pass = project.filter_vh(faces);

%Initialization of the polyhedral partition of the space
h = height(pass);
P = repmat(Polyhedron(), h, 1);
s = size(pass(1).V);
dimension = s(2) - 1;

%Projection of each face on the initial space
for i=1:h
     points = pass(i).V;
     projected_points = points(:,1:dimension);
     P(i) = Polyhedron(projected_points).minHRep();
end

end
