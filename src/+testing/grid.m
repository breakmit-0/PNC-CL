
% Generate obstacles in a grid pattern for testing
function obstacles = grid(gridW, gridH, size, spacing)
    arguments
        gridW = 4;
        gridH = 4;
        size = 5;
        spacing = 5;
    end

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
end
