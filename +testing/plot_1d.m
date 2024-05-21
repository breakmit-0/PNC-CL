
function plot_1d(oa, ob)
    
    N = size(ob, 1);
    %[x, y] = meshgrid(-10:0.1:10, 10:0.1:10);
    x = linspace(-30, 30, 2);
    for i = 1:N
       b = ob(i);

       y = x*oa(i,1) + b;
       plot(x, y);
       hold on;
    end
end
