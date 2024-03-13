
function plot_2d(oa, ob)
    
    N = size(ob, 1);
    %[x, y] = meshgrid(-10:0.1:10, 10:0.1:10);
    x = linspace(-30, 30, 2);
    y = linspace(-30, 30, 2);
    [xx,yy] = meshgrid(x,y);
    for i = 1:N
       b = ob(i);

       z = xx*oa(i,1) + yy*oa(i,2) + b;
       surf(x, y, z);
       hold on;
    end
end
