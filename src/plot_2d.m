
function plot_2d(a, oa, ob, space)
    
    N = size(ob, 1);
    %[x, y] = meshgrid(-10:0.1:10, 10:0.1:10);
    x = linspace(0, space, 2);
    y = linspace(0, space, 2);
    [xx,yy] = meshgrid(x,y);

    plot3(0, 0, 0);
    hold on;


    cmap = hsv(N);

    for i = 1:N
        b = ob(i);

        c = cmap(i, :);
        col(1, 1, :) = c;
        col(1, 2, :) = c;
        col(2, 1, :) = c;
        col(2, 2, :) = c;

        z = (xx*oa(i,1) + yy*oa(i,2) + b) - 100;
        assert_shape(z, [2 2]);
        surf(x, y, z, col);
    end

    plot(a);
end
