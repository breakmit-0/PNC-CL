
function plot_2d(a, oa, ob)
    
    N = size(ob, 1);
    %[x, y] = meshgrid(-10:0.1:10, 10:0.1:10);
    x = linspace(0, 30, 2);
    y = linspace(0, 30, 2);
    [xx,yy] = meshgrid(x,y);

    plot3(0, 0, 0);
    hold on;


    for i = 1:N
       b = ob(i);

       z = (xx*oa(i,1) + yy*oa(i,2) + b) - 100;
       surf(x, y, z, [0 0 0]);

    end

    plot(a);
end
