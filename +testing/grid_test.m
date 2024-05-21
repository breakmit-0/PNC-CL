disp("grid")

gridW = 4;
gridH = 4;
size = 5;
spacing = 5;


halfSize = size / 2;
obstacles = [];

for y = 1:gridH
    for x = 1:gridW
        cx = (size + spacing) * (x - 1);
        cy = (size + spacing) * (y - 1);
        topX = cx - halfSize;
        topY = cy - halfSize;
        botX = cx + halfSize;
        botY = cy + halfSize;

        V = [topX topY; topX botY; botX topY; botX botY];

        obstacles = [Polyhedron('V', V); obstacles];
    end
end

PolyUnion(obstacles).plot();


[oa, ob] = find_lift(obstacles);
% check_constraints(obstacles, oa, ob);
% plot_2d(obstacles, oa, ob, (size + spacing) * max(gridW, gridH));

faces = projectFacets(oa, ob);
faces.plot()
% edges = polyunionToEdges(faces);
% G = facetsToGraph(faces);

% plot(G, 'EdgeLabel', G.Edges.Weight)
